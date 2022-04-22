package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.PriorityQueue;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

public class AgenteAStar  extends AbstractPlayer {

    Vector2D avatar; 	//Posicion del avatar
	Vector2D fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta
	
	ArrayList<ACTIONS> path; //camino a la solucion
	ArrayList<Observation> grid[][]; //Grid para obtener la info del mapa

	
	// Parametros a medir
	int nodosExpandidos = 0;
	int nodosMemoria = 0;

	// Struct nodo
	public static class Node implements Comparable<Node>{
		public Vector2D posicion;
		public ACTIONS accion;
		public Node padre;
        public int f,g,h;

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
				"H : " + h + "\t" 
            );
	    }

        @Override
    	public int compareTo(Node o) {
			if(this.f < o.f)
				return -1;
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
	//distancia mah
	private int distMH(Node i, Node destino) {
		return (int) (Math.abs(i.posicion.x - destino.posicion.x) + Math.abs(i.posicion.y - destino.posicion.y));
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


		// NO TENGO QUE MIRAR SI EL HIJO ESTÁ EN CERRADOS PORQUE LA HEURÍSTICA
		// ES MONÓTONA Y POR TANTO NO HAY QUE COMPROBAR SI ESTÁ EN CERRADOS 
		

    public void AStar(Node inicio, Node fin){
		//Hashmap para almacenar en abiertos, optimo para inserccion, seleccion y busqueda
		HashMap<Vector2D, Node> abiertosMap = new HashMap<>();
		//Cola de prioridad para gruardar los nodos de abiertos segun el orden establecido
        PriorityQueue<Node> abiertos = new  PriorityQueue<>();
		//Hashmap para almacenar cerrados, optimo para inserccion, seleccion y busqueda
		HashMap<Vector2D,Node> cerrados =  new HashMap<>();

		//Insertamos el nodo iniicial
		abiertosMap.put(inicio.posicion, inicio);
		abiertos.add(inicio);

		Node current = new Node();
		Node aux = new Node(new Vector2D(0,0));
		aux.g = 1;
		int iter = 0;
		while(true){
			iter++;

			//Obtenemos el nodo con menor coste
			current = abiertosMap.get(abiertos.poll().posicion);
			abiertosMap.remove(current.posicion);
				
			if(current.posicion.equals(fin.posicion))
				break;
			nodosExpandidos++; //Expando nodo

			cerrados.put(current.posicion, current);
			current.h = distMH(current,fin);
			if(iter == 1 ) current.padre = aux;

			//Expandimos el nodo actual

			/*-------------------Arriba ------------------------*/
			Node arriba = new Node(new Vector2D(current.posicion.x, current.posicion.y -1));
			
				//SOLO ANDO SI HAY SUELO O META
			if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(fin.posicion)){				
				if(arriba.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !!");
				}else{
					boolean cerrados_contein = cerrados.containsKey(arriba.posicion);
					boolean abiertos_contein = abiertosMap.containsKey(arriba.posicion);
					arriba.h = distMH(arriba, fin);
					arriba.accion = ACTIONS.ACTION_UP;
					arriba.padre = current;
					arriba.g = g(arriba);
					arriba.CalcF();
					//Si el nodo expandido no esta ni en abiertos ni en cerrados, lo añado
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(arriba);
						abiertosMap.put(arriba.posicion,arriba);
					}else{ 
						//Si el nodo esta en abiertos pero llego por un camino mas corto lo actualizo
						if(abiertos_contein && arriba.g < abiertosMap.get(arriba.posicion).g){
							abiertos.remove(abiertosMap.get(arriba.posicion));
							abiertos.add(arriba);
							abiertosMap.put(arriba.posicion,arriba);
						}
					}
				}
			}

			/*-------------------Abajo ------------------------*/
			Node abajo = new Node(new Vector2D(current.posicion.x, current.posicion.y +1));
			if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(fin.posicion)){
				if(abajo.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !! ");
				}else{
					boolean cerrados_contein = cerrados.containsKey(abajo.posicion);
					boolean abiertos_contein = abiertosMap.containsKey(abajo.posicion);
					abajo.h = distMH(abajo, fin);
					abajo.accion = ACTIONS.ACTION_DOWN;
					abajo.padre = current;
					abajo.g = g(abajo);
					abajo.CalcF();
					
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(abajo);
						abiertosMap.put(abajo.posicion,abajo);
					}else{ 

						if(abiertos_contein && abajo.g < abiertosMap.get(abajo.posicion).g){
							abiertos.remove(abiertosMap.get(abajo.posicion));
							abiertos.add(abajo);
							abiertosMap.put(abajo.posicion,abajo);
						}
					}
				}
				
			}

			Node izquierda  = new Node(new Vector2D(current.posicion.x-1, current.posicion.y));
			izquierda.h = distMH(izquierda, fin);
			izquierda.accion = current.accion;
			
			izquierda.padre = current;
			izquierda.g = g(izquierda);
			izquierda.CalcF();
			if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(fin.posicion)){
				if(izquierda.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !!");
				}else{
					boolean cerrados_contein = cerrados.containsKey(izquierda.posicion);
					boolean abiertos_contein = abiertosMap.containsKey(izquierda.posicion);
					izquierda.h = distMH(izquierda, fin);
					izquierda.accion = ACTIONS.ACTION_LEFT;
					izquierda.padre = current;
					izquierda.g = g(izquierda);
					izquierda.CalcF();

					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(izquierda);
						abiertosMap.put(izquierda.posicion,izquierda);
					}else{ 
						if(abiertos_contein && izquierda.g < abiertosMap.get(izquierda.posicion).g){
							abiertos.remove(abiertosMap.get(izquierda.posicion));
							abiertos.add(izquierda);
							abiertosMap.put(izquierda.posicion,izquierda);
						}
					}
				}
				
			}

			Node derecha = new Node(new Vector2D(current.posicion.x+1, current.posicion.y ));
			derecha.h = distMH(derecha, fin);
			derecha.accion = ACTIONS.ACTION_RIGHT;
			
			derecha.padre = current;
			derecha.g = g(derecha);
			derecha.CalcF();
			if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(fin.posicion)){
				if(derecha.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !!");
				}else{
					boolean cerrados_contein = cerrados.containsKey(derecha.posicion);
					boolean abiertos_contein = abiertosMap.containsKey(derecha.posicion);
					derecha.h = distMH(derecha, fin);
					derecha.accion = ACTIONS.ACTION_RIGHT;
					
					derecha.padre = current;
					derecha.g = g(derecha);
					derecha.CalcF();
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(derecha);
						abiertosMap.put(derecha.posicion,derecha);
					}else{ 
						if(abiertos_contein && derecha.g < abiertosMap.get(derecha.posicion).g){
							abiertos.remove(abiertosMap.get(derecha.posicion));
							abiertos.add(derecha);
							abiertosMap.put(derecha.posicion,derecha);
						}
					}	
				}
			}
			/*System.out.println("\tLista de abiertos " + abiertos.size());
			
			Queue<Node> abiertos_aux = new PriorityQueue<>(abiertos);
		
			while (!abiertos_aux.isEmpty()) {
				System.out.println("\t"+abiertos_aux.remove());
			}
			System.out.println("\tLista de cerrados "+ cerrados.size());
			for (Entry<Vector2D, Node> entry : cerrados.entrySet()) {
				System.out.println("\t" + entry.getKey() + " = " + entry.getValue());
			}*/
		}
		//Actualizo datos
		nodosMemoria = Math.max(abiertos.size(), cerrados.size());
		//Calculo ruta
		while(current.padre != null){
			path.add(current.accion);
			current = current.padre;
		}
    }

	public AgenteAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
		fescala = new Vector2D(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
				stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

		ArrayList<Observation>[] portales = stateObs.getPortalsPositions();
		portal = portales[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		avatar =  new Vector2D(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);

		path = new ArrayList<ACTIONS>();
		grid = stateObs.getObservationGrid();
	}

    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        ACTIONS accion = ACTIONS.ACTION_NIL;
		
		Node inicial = new Node(avatar);
		Node objetivo = new Node();
		objetivo.posicion = new Vector2D(portal.x, portal.y);
		inicial.h = distMH(inicial, objetivo);
		inicial.g = 0;
		inicial.CalcF();

		if(path.isEmpty()){
			AStar(inicial, objetivo);
			
			Collections.reverse(path);
			path.remove(0); //El primer es nil
			
			//System.out.println("path: " + path);
			System.out.println("Tamaño de la ruta: " + path.size());
			System.out.println("Tiempo de cálculo: " + elapsedTimer);
			System.out.println("Nodos expandidos: " + nodosExpandidos); 
			System.out.println("Nodos en memoria: " + nodosMemoria);
		}
		
		accion = path.remove(0);
		return accion;
    }
    
}
