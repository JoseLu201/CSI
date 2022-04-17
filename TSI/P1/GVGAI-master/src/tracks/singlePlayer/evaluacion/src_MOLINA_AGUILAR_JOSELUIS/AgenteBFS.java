package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;

import core.game.Observation;
import tools.Vector2d;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;


public class AgenteBFS extends AbstractPlayer {
	Vector2D avatar; 	//Posicion del avatar
	Vector2D fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta


	ArrayList<ACTIONS> path; //Ruta hasta solucion
	ArrayList<Observation> grid[][]; //Grid para obtener la info del mapa
	//HashMap para almacenar los nodos visitados, optimo em busquedaa, insercion y
	HashMap<Vector2D, Boolean> visited = new HashMap<Vector2D, Boolean>();

	int nodosExpandidos = 0;
	int count = 0;

	// Struct nodo
	public static class Node {
		public Vector2D posicion;
		public ACTIONS accion;
		public Node padre;

		public Node() {
			posicion = new Vector2D(0, 0);
			accion = ACTIONS.ACTION_NIL;
			padre = null;
		}

		public Node(Vector2D pos){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
		}

		public String toString(){
            return(
                "Posicion : " + posicion.toString() + "\t" +
                "Accion : " + accion.toString() + "\t"
            );
        
	    }
	}

	// Pathfinding anchura
	//Optimo cuando g = 1
	void BFS(Node inicial, Node objetivo) {
		//Cola para explorar en anchura, mejor DS
		Queue<Node> cola = new LinkedList<Node>();

		//Inserto en la cola el nodo inicial
		cola.add(inicial);
		visited.put(inicial.posicion,true);
		while(!cola.isEmpty()){
			Node actual = cola.remove();
			//Obengo el primer nodo de la cola, si es solucion acabo
			if(actual.posicion.equals(objetivo.posicion)){
				while(actual.padre != null){
					//Reconstruyo la path pero al reves
					path.add(actual.accion);
					actual = actual.padre;
				}
				break;
			}
			//Sino pues expando el nodo
			nodosExpandidos++;
			

			Node arriba = new Node(new Vector2D(actual.posicion.x, actual.posicion.y - 1));
			//Si no he visitado el nodo y puedo moverme a la casilla, la meto en la cola.
			if(!visited.containsKey(arriba.posicion)){
				if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(objetivo.posicion)){
					arriba.accion = ACTIONS.ACTION_UP;
					arriba.padre = actual;
					cola.add(arriba);
					visited.put(arriba.posicion,true);
				}
			}
			
			Node abajo = new Node(new Vector2D(actual.posicion.x, actual.posicion.y + 1));
			if(!visited.containsKey(abajo.posicion) ){
				if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(objetivo.posicion)){
					abajo.accion = ACTIONS.ACTION_DOWN;
					abajo.padre = actual;
					cola.add(abajo);
					visited.put(abajo.posicion,true);
				}
			}
			
			Node izquierda = new Node(new Vector2D(actual.posicion.x - 1, actual.posicion.y));
			if(!visited.containsKey(izquierda.posicion) ){
				if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(objetivo.posicion)){
					izquierda.accion = ACTIONS.ACTION_LEFT;
					izquierda.padre = actual;
					cola.add(izquierda);
					visited.put(izquierda.posicion,true);
				}
			}
			
			Node derecha = new Node(new Vector2D(actual.posicion.x + 1, actual.posicion.y));
			if(!visited.containsKey(derecha.posicion)){
				if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() ||  derecha.posicion.equals(objetivo.posicion)){					
					derecha.accion = ACTIONS.ACTION_RIGHT;
					derecha.padre = actual;
					cola.add(derecha);
					visited.put(derecha.posicion,true);
				}
				
			}
		}
	}

	public AgenteBFS(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){

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
		
		Node inicial = new Node();
		inicial.posicion = new Vector2D(avatar.x, avatar.y);

		Node objetivo = new Node();
		objetivo.posicion = new Vector2D(portal.x, portal.y);

		if(path.isEmpty()){
			BFS(inicial, objetivo);
			
			// La lista esta al reves, le damos la vuelta
			Collections.reverse(path);
			
			//System.out.println("path: " + path);
			System.out.println("Tamaño de la ruta: " + path.size());
			System.out.println("Tiempo de cálculo: " + elapsedTimer);
			System.out.println("Nodos expandidos: " + nodosExpandidos);
			System.out.println("Nodos en memoria: " + visited.size());
		}
		
		accion = path.remove(0);
		return accion;
	}
}