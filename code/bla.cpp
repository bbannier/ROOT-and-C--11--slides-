vector<int> up_to(int n) {
  vector<int> v(n);
  iota(begin(v), end(v), 0);
  this_thread::sleep_for(chrono::minutes(5));
  return v;
}

int main() {
  packaged_task<vector<int>(int)> task(&up_to);

  auto fr = task.get_future();

  const int n = 10000000;
  thread t(move(task), n);
  t.detach();

  assert(*(fr.get().rbegin()) == n);
}
