#ifndef MDD_hdd
#define MDD_hdd

#include <vector>
#include <fstream>
#include <string>
#include "random.hpp"
using namespace std;

using Random = effolkronium::random_static;

class MDD{

    private:
        vector<vector<float>> datos;
        int n,m;
    public:
        MDD(int n);
        void read_dimension(string fichero);
        void leer_fichero(string nombre_fichero);
        float distPuntoRestoElemenetos(int f,vector<int> v);
        float diff(vector<int> posib);
        float diff_adding(vector<int> posib, int new_i);
        vector<int> greedy();
        void mostrarDatos();
        void exact_algo();

};


#endif