void pf_set(std::promise<int>&& pi) { pi.set_value(42); }

int main() {
  std::promise<int> pi;
  std::future<int> fv = pi.get_future();
  auto sfv1 = fv.share();
  auto sfv2 = sfv1;
  std::thread t(pf_set, std::move(pi));

  std::cout << sfv1.get() << std::endl;
  std::cout << sfv2.get() << std::endl;

  t.join();
}
