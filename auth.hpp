#pragma once
#include <string>

namespace KeyAuth {
    class api {
    public:
        std::string name;
        std::string ownerid;
        std::string secret;
        std::string version;
        std::string url;

        api(std::string name, std::string ownerid, std::string secret, std::string version, std::string url) {
            this->name = name;
            this->ownerid = ownerid;
            this->secret = secret;
            this->version = version;
            this->url = url;
        }
        
        void init() {
            // Initialization code
        }
    };
}
