#include "MDD.hpp"
#include <string>
#include <iostream>
#include <algorithm>
#include "random.hpp"
#include <vector>


/*

*/
using namespace std;

using Random = effolkronium::random_static;

MDD::MDD(int n, int m){
    this->n = n;
    this->m = m;
    this->datos.resize(n,vector<float>(n));
    this->distan.resize(m);
}
/*
void MDD::read_dimension(string fichero){
    ifstream file(fichero);
    string t1;
    getline(file,t1,' ');
    getline(file,t1);
    this->m = stoi(t1);
    //cout << "Num casos" << m << endl;
    file.close();
}
*/
void MDD::leer_fichero(string nombre_fichero){
    float dist;
    string t1;
    ifstream file(nombre_fichero);
    getline(file,t1);
    int i =0,j=0;
    while (file >> i >> j >> dist){
        datos[i][j] = dist;
    }
    
    file.close();
    //cout << "archivo cerrado" << endl;
}


/*
De entre todas las soluciones escojo unas localizaciones aleatorias

*/


/*
A(v) suma de las dist entre ese vertice 'v' y el resto de vertices de S

*/
/*
void print(vector<int> v){
    cout << "[";
    for(auto a : v)
        cout << a << " ";
    cout << "]\n";
}*/


vector<int> MDD::greedy(){

    vector<int> solucion;
    vector<int> cand;

    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    int max = this->n;
    auto rand = Random::get(0,max);
    auto select = cand.at(rand);//Seleccion inicial
    //Seleccionar la primera solucion de forma aleatoria
    solucion.push_back(select);
    auto delete_ps = cand.begin()+rand;
    cand.erase(delete_ps);

    while(solucion.size() < this->m ){
        
        float actual_dif = diff(solucion);
        float new_diff;
        int pos = 0;

        for(auto ele = 0; ele < cand.size(); ele++) {
            if(std::find(solucion.begin(), solucion.end(), ele) != solucion.end() )
                continue;
            new_diff = diff_adding(solucion,ele);
            for(auto i = 0; i  < cand.size();i++){
                if(std::find(solucion.begin(), solucion.end(), i) != solucion.end() )
                    continue;
                float inner = diff_adding(solucion,i);
                if(inner < new_diff){
                    new_diff = inner;
                    pos = i;
                }    
            }
        }   

        solucion.push_back(pos);
        auto index = cand.begin()+pos;
        //cout << "Añadiendo el elementos \t[" << pos <<"]"<< endl<<endl;
        cand.erase(index);
       // cout << "Solucion ";// print(solucion);
        //cout << "Candidatos "; print(cand); 
    }
    return solucion;

}

void MDD::print_check(){
    vector<int> cand;
    vector<int> solucion = {21,0,1};
    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }

    float new_diff;
    for(auto ele : cand){
        //float actual_dif = diff(solucion);
        //cout << "ACtual diff " << actual_dif << endl;
        new_diff = diff_adding(solucion,ele);
        cout << "21,0,1,"<<ele<< " ->" << new_diff <<endl;
    }
    
}
/*
21,0,i

*/



/*
Calcula la distancia desde un puntoal resto de los pntos
f -> es la fila sobre la que se aplica,
v -> es un vector con los indices de las columnas sobre las que se suman
Esta funcion recalcula muchos datos
*/
float MDD::distPuntoRestoElemenetos(int f,vector<int> v){
    float dist = 0;
    for(int i = 0; i < v.size();i++){
        dist+=this->datos[f][v[i]];
        if(datos[f][v[i]] < 0 || datos[f][v[i]] == 0)
            dist+= datos[v[i]][f];
    }
    return dist;
}

float MDD::distPuntoRestoElemenetos2(vector<int> sol,pair<int,int> cambio){
    float disp = 0;
    for(int i = 0; i < sol.size();i++){
        this->distan[i] = distPuntoRestoElemenetos(sol[i],sol);
    }
    //cout << endl;

    int last_pos = sol[cambio.first] ;
    sol[cambio.first] = cambio.second;
    this->distan[cambio.first] = distPuntoRestoElemenetos(cambio.second,sol);

    for(auto i =0; i < sol.size();i++){
        if(i != cambio.first){     
               
            if(this->datos[last_pos][sol[i]] != 0){
                if(this->datos[cambio.second][sol[i]] != 0){
                    this->distan[i] = this->distan[i] - this->datos[last_pos][sol[i]] + this->datos[cambio.second][sol[i]];
                }
                else{
                    
                    this->distan[i] = this->distan[i] - this->datos[last_pos][sol[i]] + this->datos[sol[i]][cambio.second];
                }
            }else{
                if(this->datos[cambio.second][sol[i]] != 0){
                    
                    this->distan[i] = this->distan[i] - this->datos[sol[i]][last_pos] + this->datos[cambio.second][sol[i]];
                }else{ 
                   
                    this->distan[i] = this->distan[i] - this->datos[sol[i]][last_pos] + this->datos[sol[i]][cambio.second];
                }
            }
        }
    }

    sort(distan.begin(), distan.end());
    return (distan[distan.size()-1] - distan[0] );
    
}



float MDD::diff(vector<int> posib){
    vector<float> distancias;

    for(int i = 0; i < posib.size();i++){
        distancias.push_back(distPuntoRestoElemenetos(posib[i],posib));
    }
    sort(distancias.begin(), distancias.end());
    return (distancias[distancias.size()-1] - distancias[0] );
}

float MDD::diff_adding(vector<int> posib, int new_i){
    float new_diff;
    vector<int> n = posib;
    n.push_back(new_i);

    new_diff = diff(n);
    return new_diff;


}

void MDD::mostrarDatos(){
    for(auto vec : datos){
       for(auto x : vec)
        cout << x << "\t"; 
        //cout << endl;
    }
}
/*
Genero una solucion aleatoria y luego seria ir intercambiando para generar los vecinos

Una forma de cambiar los indices seria hacer hacer una pareja de valores en la cual la primera 
posicion es el valor que cambias y el segundo seria por el cual lo cambias, con esto podemos mejorar en memoria

Para factorizar la funcion de evaluacion si solo cambiamos un elemento en los vecinos, no tendriamos que 
volver a recalcular todos los valores por solo cambiar uno

ejemplo

(0,4,6)
D0 = D04 + D06  //Esta ya no lo necesito
D4 = D40 + D46  //Si cambio el o por un 1 D4 = D4 -D04 + D14
D6 = D60 + D64
*/

float MDD::calcular_nuevo_coste(vector<int> pos,pair<int,int> cambio){
    
    float dist1 = distPuntoRestoElemenetos(cambio.first,pos);
    float dist2 = distPuntoRestoElemenetos(cambio.second,pos);
    return dist2;
}


vector<int> MDD::BL(){
    vector<int> solucion;
    vector<int> cand;
    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    
    int rand;
    for(int i = 0; i < this->m;i++){
        rand = Random::get(0,this->n-1);
        solucion.push_back(rand);
    }
    using std::remove;
    //cout << "Solucion inicial " << endl;
    for(auto i : solucion){
        //cout << i << " ";
        cand.erase(std::remove(cand.begin(), cand.end(), i), cand.end());
    }
    //cout << endl;
    

    pair<int,int> cambio;
    int index = 0;
    float new_disp;
    bool change = false;
    while(index != solucion.size() && change == false){
        for(auto i = 0; i < cand.size();i++){
            float actual_disp = diff(solucion);
            cambio = make_pair(index,cand[i]);
           //cout << "Pareja obtenida ((" << solucion[cambio.first] << ")) , " << cambio.second << endl;
            new_disp = distPuntoRestoElemenetos2(solucion,cambio);
            //cout << "Cambiando [" << solucion[cambio.first] << "] por [" << cambio.second << "] Obtengo "<< new_disp << endl;
            //cout << "Dispersion " << actual_disp << " --  " << new_disp << endl;
            if(new_disp < actual_disp  ){
                //cout << "Cambiando " << solucion[index] << " por " << cand[i] << endl;
                solucion[index] = cand[i];
                auto it = std::find(cand.begin(), cand.end(), cand[i]);
                cand.erase(it);
                index = (index +1)%solucion.size();
                change = true;
               /* for(auto a : solucion){
                    cout << a << " ";
                }
                cout << endl;*/
            }
            if(change == true){
                change = false;
            }
        }
        index++;
    }
    
    //cout <<"Dispersion final = "<<  diff(solucion) << endl;
    return solucion;
}