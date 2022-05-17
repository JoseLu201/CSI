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
        float distFactorizada(vector<int> sol,pair<int,int> cambio);
        float diff(vector<int> posib);
        float diff2(vector<int> posib);
        float fit_adding(vector<int> posib,int new_i);
        vector<int> greedy();
        void mostrarDatos();
        void exact_algo();
        void print_check();

        vector<int> BL();
        void printDatos();

        pair<vector<int>,vector<int>> generarHijosUniforme(vector<int> p1,vector<int> p2);
        pair<vector<int>,vector<int>> generarHijosPosicion(vector<int> p1,vector<int> p2);
        vector<int> reparar(vector<int> hijo);

        vector<int> AGG_uniforme();
        vector<int> AGG_posicion();
        vector<int> AGE_uniforme();
        vector<int> AGE_posicion();
        vector<int> generarPoblacion();
        int torneo(vector<vector<int>> poblacion, vector<float> fitness_i,int indiv_torneo);
        vector<int> seleccion(vector<vector<int>> poblacion,vector<float> fitness_i,int n);
        

};


#endif