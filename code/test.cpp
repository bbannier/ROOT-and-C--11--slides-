#include <algorithm>
#include <TFile.h>
#include <future>
#include <vector>
#include <map>
#include <iostream>
#include <TNtuple.h>
#include <memory>

struct FiledNtuple {
  std::unique_ptr<TFile> f = nullptr;
  std::unique_ptr<TNtuple> nt = nullptr;
  FiledNtuple(TFile* f, TNtuple* nt) :
    f(f),
    nt(nt) { }
};

int main() {
  std::vector<std::pair<std::string, std::string>> sames = {
    std::make_pair("/tmp/rcas/tmp/f.root", "n"),
    std::make_pair("/tmp/rcas/tmp/nt.root", "nt")
  };
  std::map<std::string, std::future<FiledNtuple>> nt_map;
  std::vector<std::future<FiledNtuple>> nts;

  for (int n=0; n<2000; ++n) {
    for (unsigned i=0; i<2; ++i) {
      nts.push_back(
        std::async([i, sames]() {
          TFile* f(TFile::Open(sames[i].first.c_str()));
          TNtuple* nt;
          f->GetObject(sames[i].second.c_str(), nt);

          return FiledNtuple {f, nt};
        }));
      nt_map[sames[i].first] =
        std::async([i, sames]() {
          TFile* f(TFile::Open(sames[i].first.c_str()));
          TNtuple* nt;
          f->GetObject(sames[i].second.c_str(), nt);

          nt->SetDirectory(nullptr);
          f->Close();
          f = nullptr;

          return FiledNtuple {f, nt};
        }
      );
    }
  }

  for (auto& nti : nt_map) {
    std::cout << nti.first <<"\t" << nti.second.get().nt->GetEntries() << std::endl;
  }

  std::cout << "##############################\n";

  for (auto it=nts.rbegin(); it!=nts.rend(); ++it) {
    auto nt = (*it).get();
    std::cout << nt.nt->GetName() <<" "<< nt.nt->GetEntries() << std::endl;
  }
}
