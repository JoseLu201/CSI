#ifndef MDD_hdd
#define MDD_hdd

#include <vector>
#include <fstream>
#include <string>
#include "random.hpp"
using namespace std;

using Random = effolkronium::random_static;

class MDD{

    protected:
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
        float fit_adding(vector<int> posib,int new_i);
        vector<int> greedy();
        void mostrarDatos();
        void exact_algo();
        void print_check();

        ///

        vector<int> BL();
        vector<int> BL_2(vector<int >solucion,int iteraciones, float& sol_fit);

        //P3
        vector<int> generarSolucionAleatoria();
        vector<int> generarVecino(vector<int> solucion, float &disp_vecino);
        vector<int> mutarSolucion(vector<int> solucion,float percent);
 
        vector<int> EnfriamientoSimulado(int MAX_ITERS, float& sol_fit);
        vector<int> EnfriamientoSimulado2(int MAX_ITERS, float& sol_fit, vector<int> solucion); 
        vector<int> BMB(int n_sol, int MAX_ITERS);
        vector<int> ILS(int n_sol, int BL_ITERS);
        vector<int> ILS_ES(int n_sol, int ES_ITERS);

        vector<int> generarPoblacion();
        vector<int> ALO(int ITERS);    

        int RouletteWheelSelection(vector<float> pesos); 
        //void move_to_hole(vector<pair<vector<int>,float>> &ant_lion, vector<pair<vector<int>,float>> &ant);
        void move_to_hole(pair<vector<int>,float> &ant_lion, pair<vector<int>,float> &ant, int curr_iter);
        void Random_walk();

};


        




#endif