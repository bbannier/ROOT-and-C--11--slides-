#include <cassert>
#include <vector>
#include <iostream>
#include <thread>
#include <future>
#include <numeric>
#include <chrono>

using std::vector;

vector<int> up_to(int n) {
  using std::iota;
  using std::begin;
  using std::end;
  using std::this_thread::sleep_for;
  using std::chrono::minutes;
  vector<int> v(n);
  iota(begin(v), end(v), 0);
  sleep_for(minutes(5));
  return v;
}

int main() {
  using std::packaged_task;
  using std::move;
  using std::thread;
  using std::cout;
  using std::endl;

  packaged_task<vector<int>(int)> task(&up_to);

  auto fr = task.get_future();

  const int n = 10000000;
  thread t(move(task), n);
  t.detach();

  assert(*(fr.get().rbegin()) == n);
}
