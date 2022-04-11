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

void MDD::leer_fichero(string nombre_fichero){
    float dist;
    string t1;
    ifstream file(nombre_fichero);
    getline(file,t1);
    int i =0,j=0;
    while (file >> i >> j >> dist)
        datos[i][j] = dist;
    file.close();
    //cout << "archivo cerrado" << endl;
}

void printi(vector<int> v){
    cout << "[";
    for(auto a : v)
        cout << a << " ";
    cout << "]\n";
}


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
        float new_fitness;
        int pos = 0;
        for(auto ele : cand){
            new_fitness = diff_adding(solucion,ele);
            //cout << "Fitness añadiendo [" <<ele<< "]  = " <<new_fitness <<endl;
            for(auto i: cand){
                float inner = diff_adding(solucion,i);
                 //cout << "Fitness INSIDE añadiendo [" <<i<< "]  = " <<inner <<endl;
                if(inner < new_fitness){
                    new_fitness = inner;
                    pos = i;      
                    //cout <<" Find [ " << i<<" ] = " <<new_fitness <<endl;             
                }    
            }
        }   
        solucion.push_back(pos);
        std::remove(cand.begin(),cand.end(),pos);
    }
    return solucion;
}

//Este es el bueno
vector<int> MDD::greedy_2(){
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
        //float actual_dif = diff(solucion);
        float new_fitness;
        int pos = 0;
        float min = 10000000.0f;
        for(auto ele : cand){
            
            new_fitness = diff_adding(solucion,ele);
            //cout << "Fitness añadiendo [" <<ele<< "]  = " <<new_fitness <<endl;
            if(new_fitness < min){
                pos = ele;
                min = new_fitness;
                //cout <<" Find better [ " << ele<<" ] = " <<min <<endl;        
            }
        }   
        solucion.push_back(pos);
        std::remove(cand.begin(),cand.end(),pos);
        //printi(solucion);
    }
    return solucion;
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

float MDD::diff_adding2(vector<int> posib,vector<int> cand, int new_i){
    float new_diff;
    posib.push_back(cand[new_i]);
    new_diff = diff(posib);
    posib.pop_back();
    return new_diff;
}
float MDD::diff_adding(vector<int> posib, int new_i){
    float new_diff;
    posib.push_back(new_i);
    new_diff = diff(posib);
    posib.pop_back();
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

vector<int> MDD::BL(){

    vector<int> solucion;
    vector<int> cand;
    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    
    int rand;
    for(int i = 0; i < this->m;i++){
        rand = Random::get(0,this->n-1);
        if(std::find(solucion.begin(), solucion.end(), rand) == solucion.end())
            solucion.push_back(rand);
        else{
             rand = Random::get(0,this->n-1);
             solucion.push_back(rand);
        }
    }
    using std::remove;
    cout << "Solucion inicial " << endl;
    for(auto i : solucion){
        cout << i << " ";
        cand.erase(std::remove(cand.begin(), cand.end(), i), cand.end());
    }
    
    cout << endl;/*
    cout << "Fitness inicial = " << diff(solucion);
    cout << endl;
    */
    Random::shuffle( cand.begin( ), cand.end( ) );
    pair<int,int> cambio;
    int index = 0;
    float new_disp;
    bool change = false;
    int maxIters = 100000;
    int iter = 0;
    while(change == false && iter < maxIters){
        cout << "Candidatos " << endl;
            for(auto a : cand){
                    cout << a << " ";
                }
                cout << endl;
        for(int i : cand){
            float actual_disp = diff(solucion);
            //cout << "Elemento de cand -> " << i << endl;
            cambio = make_pair(index,i);
            cout << "Pareja obtenida (" << solucion[cambio.first] << ") , " << cambio.second << endl;
            new_disp = distPuntoRestoElemenetos2(solucion,cambio);
            cout << "Cambiando [" << solucion[cambio.first] << "] por [" << cambio.second << "] Obtengo "<< new_disp << endl;
            cout << "Dispersion " << actual_disp << " --  " << new_disp << endl;
            if(new_disp < actual_disp  ){
                cout << "->CAMBIANDO " << solucion[index] << " por " << i << endl;
                solucion[index] = i;
                
                cand.erase(std::remove(cand.begin(), cand.end(), i), cand.end());
                index = (index +1)%solucion.size();
                change = true;
                
                for(auto a : solucion){
                    cout << a << " ";
                }
                cout << endl;
            }

            if(change == true and index == solucion.size()){
                index = 0 ;
                change = false;
            }/*
            cout << "Elemento de cand(fin)-> " << i << endl;
            for(auto a : cand){
                    cout << a << " ";
                }
                cout << endl;*/
            iter++;
        }
        index++;
    }
    return solucion;
}


vector<int> MDD::BL_2(){
    vector<int> solucion;
    vector<int> cand;

    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    
    //Genero 
    int rand;
    for(int i = 0; i < this->m;i++){
        rand = Random::get(0,this->n-1);
        if(std::find(solucion.begin(), solucion.end(), rand) == solucion.end())
            solucion.push_back(rand);
        else{
             rand = Random::get(0,this->n-1);
             solucion.push_back(rand);
        }
    }
    using std::remove;
    //cout << "Solucion inicial " << endl;
    for(auto i : solucion){
        //cout << i << " ";
        cand.erase(std::remove(cand.begin(), cand.end(), i), cand.end());
    }

    /*cout << "Candidatos " << endl;
    for(auto a : cand)
    cout << a << " ";
    cout << endl;*/
    
    Random::shuffle( cand.begin( ), cand.end( ) );


    pair<int,int> cambio;
    int index = 0;
    float new_disp;
    bool change = true;
    bool end = false;
    bool first = true;
    int maxIters = 1000;
    int iter = 0;

    while(iter < maxIters && change == true){
        if(first){
            change = false;
            first = false;
        }
        for(int i = 0; i < cand.size();i++){
            float actual_disp = diff(solucion);
            cambio = make_pair(index,cand[i]);
            new_disp = distPuntoRestoElemenetos2(solucion,cambio);                                                                  //10 24 18 23 0 3 7 
            //cout << "Cambiando [" << solucion[cambio.first] << "] por [" << cambio.second << "] Obtengo "<< new_disp << endl;       //17 8 20 12 5 19 22 6 2 11 1 21 13 15 16 14 9 4 
            //cout << "Dispersion " << actual_disp << " --  " << new_disp << "  [[ "<<change<<" ]] " << endl;
            if(new_disp < actual_disp  ){
                //cout << " --> Cambiando " << solucion[index] << " por " << cand[i] << endl;
                solucion[index] = cand[i];
                cand.erase(std::remove(cand.begin(), cand.end(), cand[i]), cand.end());
                index = (index +1)%(solucion.size());
                //cout << " --> Nos movemos a -> {" << index << "}" << endl;
                change = true;
                i = -1;
            }
            //Si sobre ese elemente no mejora pero no es el ultimo
            //cout << "Sol index " << solucion[index] << " " << solucion[solucion.size()-1]<<endl;
            if(!change and solucion[index] != solucion[solucion.size()-1]){
                //cout << "Cand i " << cand[i] << " " << cand[cand.size()-1]<<endl;
                if(cand[i] == cand[cand.size()-1]){
                    index = (index +1)%(solucion.size());
                    //cout << "Index++ " << index << endl;
                    i = -1;
                }
            }
                
            //cout << "Sol index " << solucion[index] << " " << solucion[solucion.size()-1]<<endl;
            if(solucion[index] == solucion[solucion.size()-1]){
                if(change){
                    index = 0 ;
                    i = -1;
                    change = false;
                    end = false;
                   /*cout <<"__Solucion [";
                    for(auto a : solucion)
                        cout << a << " ";
                    cout <<"]"<< endl;cout << "Candidatos [";
                    for(auto a : cand)
                        cout << a << " ";
                    cout  <<"]"<< endl;*/
                }
            }

           

        iter++;
        }
        index = (index +1)%(solucion.size());

    }
    //cout << "Iteraciones "<< iter << endl; 
    //cout <<"Dispersion final = "<<  diff(solucion) << endl;
    return solucion;
}

/*
__Solucion [32 30 5 36 4 ]
Candidatos [1 19 17 22 12 2 29 15 49 48 8 27 25 21 42 43 6 20 13 10 45 14 31 16 41 7 38 35 46 47 37 34 23 3 18 ]

*/