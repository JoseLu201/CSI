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
        int n,m;
        vector<vector<float>> datos;
        

        
    public:
        vector<float> distan;
        MDD(int n,int m );
        void read_dimension(string fichero);
        void leer_fichero(string nombre_fichero);
        float distPuntoRestoElemenetos(int f,vector<int> v);
        float distPuntoRestoElemenetos2(vector<int> sol,pair<int,int> cambio);
        float diff(vector<int> posib);
        float diff_adding(vector<int> posib,int new_i);
        float diff_adding2(vector<int> posib,vector<int> cand,int new_i);
        vector<int> greedy();
        vector<int> greedy_2();
        vector<int> rand_greedy();
        void mostrarDatos();
        void exact_algo();
        void print_check();

        ///

        vector<int> BL();
        vector<int> BL_2();
        float calcular_nuevo_coste(vector<int> pos,pair<int,int> cambio);
        

};


#endif