#ifndef MDD_hdd
#define MDD_hdd

#include <vector>
#include <fstream>
#include <string>
#include "random.hpp"
#include <set>
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
        float distPuntoRestoElemenetosNonBin(int f,vector<int> v);
        float distFactorizada(vector<int> sol,pair<int,int> cambio);
        float distFactorizadaNonBin(vector<int> sol,pair<int,int> cambio);
        float diff(vector<int> posib);
        float diffNonBin(vector<int> posib);
        float fit_adding(vector<int> posib,int new_i);
        vector<int> greedy();
        void mostrarDatos();
        void exact_algo();
        void print_check();

        vector<int> BL();
        vector<int> Bin_BL(vector<int> data);
        void printDatos();

        pair<vector<int>,vector<int>> generarHijosUniforme(vector<int> p1,vector<int> p2);
        pair<vector<int>,vector<int>> generarHijosPosicion(vector<int> p1,vector<int> p2);
        vector<int> reparar(vector<int> hijo);

        vector<int> AGG_uniforme();
        vector<int> AGG_posicion();
        vector<int> AGE_uniforme();
        vector<int> AGE_uniforme_antiguo();
        vector<int> AGE_posicion();
        vector<int> generarPoblacion();
        int torneo(vector<vector<int>> poblacion, vector<float> fitness_i,int indiv_torneo);
        set<int> seleccion(vector<vector<int>> poblacion,vector<float> fitness_i,int n);

        
        vector<int> AM_all();
        vector<int> AM_subset();
        vector<int> AM_best();

        template <typename T>
        vector<size_t> sort_indexes(const vector<T> &v) {

        // initialize original index locations
        vector<size_t> idx(v.size());
        iota(idx.begin(), idx.end(), 0);

        // sort indexes based on comparing values in v
        // using std::stable_sort instead of std::sort
        // to avoid unnecessary index re-orderings
        // when v contains elements of equal values 
        stable_sort(idx.begin(), idx.end(),
        [&v](size_t i1, size_t i2) {return v[i1] < v[i2];});

        return idx;
    }
    vector<int>  change_rep2(vector<int> hijo);
        

};


#endif