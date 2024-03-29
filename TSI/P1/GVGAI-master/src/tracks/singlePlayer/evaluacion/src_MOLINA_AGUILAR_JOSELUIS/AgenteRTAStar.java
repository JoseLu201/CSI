package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Map.Entry;
import java.util.concurrent.TimeUnit;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

public class AgenteRTAStar  extends AbstractPlayer{
    Vector2D avatar; 	//Posicion del avatar
	Vector2D fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta
	
	LinkedHashMap<Vector2D, Node> path = new LinkedHashMap<>();
	Queue<ACTIONS> ansPath =  new LinkedList<>();
	ArrayList<Observation> grid[][];

    int nodosMemoria = 0;
    int nodosExpandidos = 0;

    Node current;
    int path_size = 0;

    public static class Node implements Comparable<Node>{
		public Vector2D posicion;
		public ACTIONS accion;
		public Node padre;
        public int f,g,h;
        //Hashmap para ir almacenando los valores de H
        static private HashMap<Vector2D, Integer> learningRule = new HashMap<>();
		

		public Node() {
			posicion = new Vector2D(0, 0);
			accion = ACTIONS.ACTION_NIL;
			padre = null;
            f = 0;
		}

        public Node(Node o) {
			this.accion = o.accion;
			this.f = o.f;
			this.g = o.g;
			this.h = o.h;
			this.padre = o.padre;
			this.posicion = o.posicion;
		}

		public Node(Vector2D pos){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
		}
        public Node(Vector2D pos, int new_g,int new_h){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
			g = new_g;
			h = new_h;
            //f = g+h;
		}
		public Node(Vector2D pos, int new_g){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
			g = new_g;
		}
		public void CalcF(){
			this.f = this.g+this.h;
		}
        public String toString(){
            return(
                "Posicion : " + posicion.toString() + "\t" +
                "Accion : " + accion.toString() + "\t" +
				"F : " + f + "\t" +
				"G : " + g + "\t" +
				"H : " + h + "\t" +
				"Tiene Padre : " +(padre!=null)
            );
        
	    }
        //Ditancia manhhatan
        public int distMH(Vector2d portal){
            if(learningRule.containsKey(this.posicion)) return learningRule.get(this.posicion);
            return (int) (Math.abs(this.posicion.x - portal.x) + Math.abs(this.posicion.y - portal.y));
        }
        public int distMH(Vector2D portal){
            if(learningRule.containsKey(this.posicion))
                return learningRule.get(this.posicion);
            return (int) (Math.abs(this.posicion.x - portal.x) + Math.abs(this.posicion.y - portal.y));
        }
        //Seguimos la regla de aprendizaje max entre el h actual y el del segundo mejor hijo
        public void updateH(int secondBestH) {
		    h = Math.max(h, 1 + secondBestH);
		    learningRule.put(posicion, h);      //Añadimos al hashmap la posicion con su h correspondiente
        }


        @Override
    	public int compareTo(Node o) {
			if(this.f < o.f){
				return -1;}
			else if(this.f > o.f)
				return 1;
			else if(this.f == o.f){
				if(this.g < o.g)
					return -1;
				else if(this.g > o.g)
					return 1;
				else if(this.g == o.g){
					  if(this.accion == ACTIONS.ACTION_UP && o.accion == ACTIONS.ACTION_DOWN) return -1; 
					else if(this.accion == ACTIONS.ACTION_UP && o.accion == ACTIONS.ACTION_LEFT) return -1; 
					else if(this.accion == ACTIONS.ACTION_UP && o.accion == ACTIONS.ACTION_RIGHT) return -1;


					else if(this.accion == ACTIONS.ACTION_DOWN && o.accion == ACTIONS.ACTION_LEFT) return -1;
					else if(this.accion == ACTIONS.ACTION_DOWN && o.accion == ACTIONS.ACTION_RIGHT) return -1;

					else if(this.accion == ACTIONS.ACTION_LEFT && o.accion == ACTIONS.ACTION_RIGHT) return -1;

					else if(this.accion == ACTIONS.ACTION_RIGHT && o.accion == ACTIONS.ACTION_LEFT) return 1; 
					else if(this.accion == ACTIONS.ACTION_RIGHT && o.accion == ACTIONS.ACTION_DOWN) return 1;
					else if(this.accion == ACTIONS.ACTION_RIGHT && o.accion == ACTIONS.ACTION_UP) return 1;

					else if(this.accion == ACTIONS.ACTION_LEFT && o.accion == ACTIONS.ACTION_UP) return 1; 
					else if(this.accion == ACTIONS.ACTION_LEFT && o.accion == ACTIONS.ACTION_DOWN) return 1;
					
					else if(this.accion == ACTIONS.ACTION_DOWN && o.accion == ACTIONS.ACTION_UP) return 1;
				}
			}

			return 0;
    	}
		
		@Override
		public boolean equals(Object o){
			if (o == this) {
				return true;
			}
			if (o.getClass() != this.getClass()) {
				return false;
			}
	
			final Node other = (Node) o;
			if ((this.posicion == null) ? (other.posicion != null) : !this.posicion.equals(other.posicion)) {
				return false;
			}
			return true;
		}
    }

    public void getBestChild(Node current2, ArrayList<Node> hijos) {
        int secondBestH = 0;

		if (hijos.size() > 1) secondBestH = hijos.get(1).h; // Si tengo mas de 1 hijo escogo el segundo.
		else secondBestH = hijos.get(0).h;                  //Sino cojo el unico que tengo
        
		// Se actualiza el coste h del nodo con dicho mínimo
		current.updateH(secondBestH);
    }
    //Calcula el valor de  g de un nodo n a partir del numero de padres que tenga
    public int g(Node n){
        Node aux = new Node(n);
        int g = 0;
        while(aux.padre != null){
            aux = aux.padre;
            g++;
        }
        return g-1;
    }

    public ArrayList<Node> GenerarHijosOrdenados(Node current){
        //Vector donde ordeno los sucesores del nodo actual
		ArrayList<Node> vecinos = new ArrayList<>();
        boolean noneGeneratede = false;
        while(!noneGeneratede && vecinos.size() == 0){
            Node arriba = new Node(new Vector2D(current.posicion.x, current.posicion.y -1));
            if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(portal)){				
                if(current.padre != null){
                    if(!arriba.posicion.equals(current.padre.posicion)){
                        arriba.h = arriba.distMH(portal);
                        arriba.accion = ACTIONS.ACTION_UP;
                        arriba.padre = current;
                        arriba.g = g(arriba);
                        arriba.CalcF();
                        vecinos.add(arriba);
                    }
                }
            }

            Node abajo =  new Node(new Vector2D(current.posicion.x, current.posicion.y+1));
            if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(portal)){				
                if(current.padre != null){
                    if(!abajo.posicion.equals(current.padre.posicion)){
                        abajo.h = abajo.distMH(portal);
                        abajo.accion = ACTIONS.ACTION_DOWN;
                        abajo.padre = current;
                        abajo.g = g(abajo);
                        abajo.CalcF();
                        vecinos.add(abajo);
                    }
                }
            }
                
            Node izquierda = new Node(new Vector2D(current.posicion.x-1, current.posicion.y ));
            if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(portal)){				
                if(current.padre != null){
                    if(!izquierda.posicion.equals(current.padre.posicion)){
                        izquierda.h = izquierda.distMH(portal);
                        izquierda.accion = ACTIONS.ACTION_LEFT;
                        izquierda.padre = current;
                        izquierda.g = g(izquierda);
                        izquierda.CalcF();
                        vecinos.add(izquierda);
                    }
                }
            }

            Node derecha = new Node(new Vector2D(current.posicion.x+1, current.posicion.y ));			
            if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(portal)){
                if(current.padre != null){
                    if(!derecha.posicion.equals(current.padre.posicion)){
                        derecha.h = derecha.distMH(portal);
                        derecha.accion = ACTIONS.ACTION_RIGHT;
                        derecha.padre = current;
                        derecha.g = g(derecha);
                        derecha.CalcF();
                        vecinos.add(derecha);
                        
                    }
                }
            }
            //Si no he generado ningun hijo, intento volver a generalos. (Caso de callejon sin salida)
            if(vecinos.size() == 0){
                noneGeneratede = false;
                current.padre.posicion = current.padre.padre.posicion;
                vecinos = GenerarHijosOrdenados(current);
            }
            else
                noneGeneratede = true;
        }


		Collections.sort(vecinos, new Comparator<Node>() {
			public int compare(Node o1, Node o2){
     			return o1.compareTo(o2);
  			}
		});
        return vecinos;
    }

    public AgenteRTAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
		fescala = new Vector2D(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
				stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

		ArrayList<Observation>[] portales = stateObs.getPortalsPositions();
		portal = portales[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		avatar =  new Vector2D(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);
        
        Node aux = new Node();
		grid = stateObs.getObservationGrid();
        current = new Node(new Vector2D(avatar));
        current.g = 0;
        current.h = current.distMH(portal); //Calculo/compruebo la h del nodo actual
        current.CalcF();
        current.padre = aux;
        path_size = 0;
        
	}

    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
		long tInicio = System.nanoTime();
        ArrayList<Node> hijos = GenerarHijosOrdenados(current);
        path_size++; 
        getBestChild(current, hijos);
        current = hijos.get(0);
		long tFin = System.nanoTime();
		long executionTime = (tFin - tInicio);
		if (current.posicion.equals(portal)){
            //En rta los nodos expandidos son los pasos que he realizado
			nodosExpandidos = path_size;
			nodosMemoria = Node.learningRule.size();
			executionTime = TimeUnit.MILLISECONDS.convert(executionTime, TimeUnit.NANOSECONDS);
			System.out.println("Tamaño de la ruta: " + path_size);
			System.out.println("Tiempo de cálculo(Elapsed): " + elapsedTimer);
            System.out.println("Tiempo de cálculo: " + executionTime +" ms");
			System.out.println("Nodos expandidos: " + nodosExpandidos); 
			System.out.println("Nodos en memoria: " + nodosMemoria);
		}
		return current.accion;
    }
}
