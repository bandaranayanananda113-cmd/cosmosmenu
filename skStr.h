#pragma once
#include <string>
#include <array>
#include <cstddef>

#ifndef FORCEINLINE
#define FORCEINLINE __attribute__((always_inline)) inline
#endif

namespace skc {
    template <std::size_t N, char K, typename T>
    class skCrypter {
    public:
        std::array<char, N> _storage;

        FORCEINLINE constexpr skCrypter(const T* data) {
            for (std::size_t i = 0; i < N; ++i) {
                _storage[i] = data[i] ^ K;
            }
        }

        FORCEINLINE const char* get() {
            for (std::size_t i = 0; i < N; ++i) {
                _storage[i] = _storage[i] ^ K;
            }
            return _storage.data();
        }
    };
}

#define skCrypt(str) []() { \
    constexpr char key = __TIME__[4] ^ __TIME__[7]; \
    constexpr std::size_t len = sizeof(str); \
    static auto crypted = skc::skCrypter<len, key, char>(str); \
    return crypted.get(); \
}()
