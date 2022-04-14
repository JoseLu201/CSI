package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;
import java.util.PriorityQueue;
import java.util.Queue;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

public class AgenteAStar  extends AbstractPlayer {

    Vector2d avatar; 	//Posicion del avatar
	Vector2d fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta

	ArrayList<Vector2d> walls;
	ArrayList<ACTIONS> path;
	ArrayList<Observation> grid[][];

	
	// Parametros a medir
	int nodosExpandidos = 0;
		int nodosMemoria = 0;

	// Struct nodo
	public static class Node implements Comparable<Node>{
		public Vector2d posicion;
		public ACTIONS accion;
		public Node padre;
        public int f,g,h;

		

		public Node() {
			posicion = new Vector2d(0, 0);
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

		public Node(Vector2d pos){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
		}
        public Node(Vector2d pos, int new_g,int new_h){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
			g = new_g;
			h = new_h;
            //f = g+h;
		}
		public Node(Vector2d pos, int new_g){
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
				else return 1;
			}
			return 0;
    	}
		public Object getPos() {
			return posicion;
		}
    }

	private int distMH(Node i, Node destino) {
		return (int) (Math.abs(i.posicion.x - destino.posicion.x) + Math.abs(i.posicion.y - destino.posicion.y));
	}

	int g(Node n){
		Node aux = new Node(n);
		int g = 0;
		while(aux.padre != null){
			aux = aux.padre;
			g++;
		}
		return g-1;
	}

		// NO TENGO QUE MIRAR SI EL HIJO ESTÁ EN CERRADOS PORQUE LA HEURÍSTICA (DISTANCIA MANHATTAN)
		// ES UNA HEURÍSTICA MONÓTONA Y POR TANTO NO HAY QUE COMPROBAR SI ESTÁ EN CERRADOS 
		// (VISTO Y DEMOSTRADO EN TEORÍA)

	public boolean containsName(final Queue<Node> list, final Vector2d pos){
		return list.stream().filter(o -> o.getPos().equals(pos)).findFirst().isPresent();
	}
	public boolean containsName(final ArrayList<Node> list, final Vector2d pos){
		return list.stream().filter(o -> o.getPos().equals(pos)).findFirst().isPresent();
	}
    public void AStar(Node inicio, Node fin){
        Queue<Node> abiertos = new  PriorityQueue<>();
		ArrayList<Node> cerrados = new ArrayList<Node>();
		abiertos.add(inicio);

		Node current = new Node();
		Node aux = new Node(new Vector2d(0,0));
		aux.g = 1;
		int iter = 0;
		
		while(true){
			//System.out.println("------------------------------------------------------------------");
			iter++;
			
			current = abiertos.remove();

			//System.out.println("CURRENT "+ current.toString());

			if(current.posicion.equals(fin.posicion))
				break;
			nodosExpandidos++;
			

			cerrados.add(current);
			current.h = distMH(current,fin);
			if(iter == 1 )
				current.padre = aux;

			/*-------------------Arriba ------------------------*/
			Node arriba = new Node(new Vector2d(current.posicion.x, current.posicion.y -1));
			
			arriba.h = distMH(arriba, fin);
			
			arriba.accion = current.accion;
			arriba.padre = current;
			arriba.g = g(arriba);
			arriba.CalcF();
			
			if(!walls.contains(arriba.posicion)){
				if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(fin.posicion)){
					
					
					//boolean cerrados_contein = cerrados.contains(arriba);
					//boolean abiertos_contein = abiertos.contains(arriba);
					boolean cerrados_contein = containsName(cerrados, arriba.posicion);
					boolean abiertos_contein = containsName(abiertos, arriba.posicion);
					//System.out.println("->Arriba "+ arriba.toString());
					arriba.accion = ACTIONS.ACTION_UP;
					
					if(arriba.posicion == current.padre.posicion){
						continue;
					}
					if(cerrados_contein && abiertos_contein){
						abiertos.remove(arriba);
					}
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(arriba);
						//System.out.println("Arriba no visitado,aña " + arriba.toString());
					}else if(abiertos_contein && current.g < arriba.g){
						abiertos.remove(arriba);
						arriba.g = g(arriba);
						abiertos.add(arriba);
						//System.out.println("Entra3 arriba");
					}
				}
			}
			/*-------------------Abajo ------------------------*/
			Node abajo = new Node(new Vector2d(current.posicion.x, current.posicion.y +1));
			abajo.h = distMH(abajo, fin);
			
			abajo.accion = current.accion;
			abajo.padre = current;
			abajo.g = g(abajo);
			abajo.CalcF();
			

			if(!walls.contains(abajo.posicion)){
				if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(fin.posicion)){
					boolean cerrados_contein = containsName(cerrados, abajo.posicion);
					boolean abiertos_contein = containsName(abiertos, abajo.posicion);
					//System.out.println("->Abajo "+ abajo.toString());
					abajo.accion = ACTIONS.ACTION_DOWN;
					if(abajo.posicion == current.padre.posicion){
						continue;
					}
					if(cerrados_contein && abiertos_contein){
						abiertos.remove(abajo);
					}
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(abajo);
						//System.out.println("Abajo no visitado,aña " + abajo.toString());
					}else if(abiertos_contein && current.g < abajo.g){
						abiertos.remove(abajo);
						abajo.g = g(abajo);
						abiertos.add(abajo);
						//System.out.println("Entra3 abajo");
					}
					
				}
			}

			Node izquierda  = new Node(new Vector2d(current.posicion.x-1, current.posicion.y));
			izquierda.h = distMH(izquierda, fin);
			izquierda.accion = current.accion;
			
			izquierda.padre = current;
			izquierda.g = g(izquierda);
			izquierda.CalcF();

			if(!walls.contains(izquierda.posicion)){
				if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(fin.posicion)){
					boolean cerrados_contein = containsName(cerrados, izquierda.posicion);
					boolean abiertos_contein = containsName(abiertos, izquierda.posicion);
					//System.out.println("->Izquierda "+ izquierda.toString());
					izquierda.accion = ACTIONS.ACTION_LEFT;
					if(izquierda.posicion == current.padre.posicion){
						continue;
					}
					if(cerrados_contein && abiertos_contein){
						abiertos.remove(izquierda);
					}
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(izquierda);
						//System.out.println("Izquierda no visitado,aña " + izquierda.toString());
					}else if(abiertos_contein && current.g < izquierda.g){
						abiertos.remove(izquierda);
						izquierda.g = g(izquierda);
						abiertos.add(izquierda);
						//System.out.println("Entra3 izquierda");
					}
					
				}
			}

			Node derecha = new Node(new Vector2d(current.posicion.x+1, current.posicion.y ));
			derecha.h = distMH(derecha, fin);
			derecha.accion = current.accion;
			
			derecha.padre = current;
			derecha.g = g(derecha);
			derecha.CalcF();
			if(!walls.contains(derecha.posicion)){
				if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(fin.posicion)){
					boolean cerrados_contein = containsName(cerrados, derecha.posicion);
					boolean abiertos_contein = containsName(abiertos, derecha.posicion);
					//System.out.println("->Derecha "+ derecha.toString());
					derecha.accion = ACTIONS.ACTION_RIGHT;
					if(derecha.posicion == current.padre.posicion){
						continue;
					}
					if(cerrados_contein && abiertos_contein){
						abiertos.remove(derecha);
					}
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(derecha);
						//System.out.println("Derecha no visitado,aña " + derecha.toString());
					}else if(abiertos_contein && current.g < derecha.g){
						abiertos.remove(derecha);
						derecha.g = g(derecha);
						abiertos.add(derecha);
						//System.out.println("Entra3 derecha");
					}	
							

				}
			}

			/*System.out.println("\tLista de abiertos " + abiertos.size());
			Queue<Node> abiertos_aux = new PriorityQueue<>(abiertos);
		
			while (!abiertos_aux.isEmpty()) {
				System.out.println("\t"+abiertos_aux.remove());
			}
			System.out.println("\tLista de cerrados");
			for(Node n : cerrados)
				System.out.println("\t"+n);
			*/
			if(abiertos.size() > nodosMemoria){
				nodosMemoria = abiertos.size();
			}
			
			if(cerrados.size() > nodosMemoria){
				nodosMemoria = cerrados.size();
			}
		}

		while(current.padre != null){
			path.add(current.accion);
			current = current.padre;
		}
    }

	public AgenteAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
		fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
				stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

		ArrayList<Observation>[] portales = stateObs.getPortalsPositions();
		portal = portales[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);
		
		walls = new ArrayList<Vector2d>();
		//Almaceno los muros en un vector de posiciones.
		for(Observation obs : stateObs.getImmovablePositions()[0]){
			Vector2d wall = obs.position;
			wall.x = Math.floor(wall.x / fescala.x);
			wall.y = Math.floor(wall.y / fescala.y);
			walls.add(wall);
		}

		path = new ArrayList<ACTIONS>();
		grid = stateObs.getObservationGrid();

	}

    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        ACTIONS accion = ACTIONS.ACTION_NIL;
		
		Node inicial = new Node(avatar);
		Node objetivo = new Node(portal);
		inicial.h = distMH(inicial, objetivo);
		inicial.g = 0;
		inicial.CalcF();

		if(path.isEmpty()){
			AStar(inicial, objetivo);
			
			// La lista esta al reves, le damos la vuelta
			Collections.reverse(path);
			path.remove(0); //El primer es nil
			
			System.out.println("path: " + path);
			System.out.println("Tamaño de la path: " + path.size());
			System.out.println("Tiempo de cálculo: " + elapsedTimer);
			System.out.println("Nodos expandidos: " + nodosExpandidos); 
			System.out.println("Nodos en memoria: " + nodosMemoria);
		}
		
		accion = path.remove(0);
		return accion;
    }
    
}
