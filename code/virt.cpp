struct A { const int n = 1; };
struct B { const int n = 2; };

template <typename T> struct wrapped {
  wrapped() : sp(new T) { }
  wrapped(T* a) : sp(a) { }
  std::shared_ptr<T> sp;
  std::shared_ptr<T> operator->() const { return sp; }

  static T* New() { return new T(); }
};

// VIA TAG DISPATCH
// this could be used as the return value for anything
// returning from some storage. Breaks the current API.
template <typename T> wrapped<T> wrap(T* a) {
  return wrapped<T>(a);
}

// via CRTP
// Redefine all types to be wrapped. Doesn't require
// changing the API, but breaks the ABI since it adds a base
// class, members and functions.
class M : public wrapped<M> {
  friend wrapped<M>;
  M() : wrapped<M>(this) { }
  public:
  const int n = 10;
};

int main() {
#if 0
  auto wa = wrap(new A);
  auto wb = wrap(new B);
  std::cout << typeid(wa.sp).name() << std::endl;
  std::cout << wa->n << std::endl;
  std::cout << wb->n << std::endl;
#endif
#if 0
  auto m = M::New();
  auto sp = m->sp;
  std::cout << m->sp.unique() << std::endl;
  std::cout << m->n << std::endl;

  auto m2 = M::New();
  //std::cout << m2.sp.unique() << std::endl;
  std::cout << m2->n << std::endl;
#endif
#if 0
  typedef wrapped<A> w_a;
  typedef wrapped<B> w_b;
  const w_a wa;
  w_b w;
  std::cout << w->n << std::endl;
  auto wap = new w_a;
  std::cout << wap->n << std::endl;
#endif
}
