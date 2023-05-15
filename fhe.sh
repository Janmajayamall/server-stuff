# clone repos 
git clone https://github.com/Janmajayamall/bfv.git
git clone https://github.com/Janmajayamall/fhe.rs.git
git clone https://github.com/openfheorg/openfhe-development.git

# install openfhe
cd openfhe-development && git checkout v1.0.3
mkdir build && cd build
cmake .. 
make -j
sudo make install
