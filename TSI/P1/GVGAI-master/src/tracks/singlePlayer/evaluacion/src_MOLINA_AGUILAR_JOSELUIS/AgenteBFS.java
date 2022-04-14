package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;

import core.game.Observation;
import tools.Vector2d;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.Queue;

public class AgenteBFS extends AbstractPlayer {
	Vector2d avatar; 	//Posicion del avatar
	Vector2d fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta

	ArrayList<Vector2d> walls;
	ArrayList<ACTIONS> path;
	ArrayList<Observation> grid[][];
	ArrayList<Vector2d> visited;
	
	// Parametros a medir
	int nodosExpandidos = 0;
	int count = 0;

	// Struct nodo
	public static class Node {
		public Vector2d posicion;
		public ACTIONS accion;
		public Node padre;

		public Node() {
			posicion = new Vector2d(0, 0);
			accion = ACTIONS.ACTION_NIL;
			padre = null;
		}

		public Node(Vector2d pos){
			posicion = pos;
			accion = ACTIONS.ACTION_NIL;
			padre = null;
		}
	}

	// Pathfinding anchura
	void BFS(Node inicial, Node objetivo) {
		Queue<Node> cola = new LinkedList<Node>();
		cola.add(inicial);
		visited.add(inicial.posicion);
		
		while(!cola.isEmpty()){
			Node actual = cola.remove();

			if(actual.posicion.equals(objetivo.posicion)){
				while(actual.padre != null){
					//Reconstruyo la path pero al reves
					path.add(actual.accion);
					actual = actual.padre;
				}
				break;
			}
			
			nodosExpandidos++;
			// Casilla arriba
			Node arriba = new Node(new Vector2d(actual.posicion.x, actual.posicion.y - 1));
			if(!visited.contains(arriba.posicion) && !walls.contains(arriba.posicion)){
				if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || grid[(int) arriba.posicion.x][(int) arriba.posicion.y].get(0).itype == 3){
					arriba.accion = ACTIONS.ACTION_UP;
					arriba.padre = actual;
					cola.add(arriba);
					visited.add(arriba.posicion);
				}
			}
			
			// Casilla abajo
			Node abajo = new Node(new Vector2d(actual.posicion.x, actual.posicion.y + 1));
			if(!visited.contains(abajo.posicion) && !walls.contains(abajo.posicion)){
				if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || grid[(int) abajo.posicion.x][(int) abajo.posicion.y].get(0).itype == 3){
					abajo.accion = ACTIONS.ACTION_DOWN;
					abajo.padre = actual;
					cola.add(abajo);
					visited.add(abajo.posicion);
				}
			}
			
			// Casilla izquierda
			Node izquierda = new Node(new Vector2d(actual.posicion.x - 1, actual.posicion.y));

			if(!visited.contains(izquierda.posicion) && !walls.contains(izquierda.posicion)){
				if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].get(0).itype == 3){
					izquierda.accion = ACTIONS.ACTION_LEFT;
					izquierda.padre = actual;
					cola.add(izquierda);
					visited.add(izquierda.posicion);
				}
			}
			
			// Casilla derecha
			Node derecha = new Node(new Vector2d(actual.posicion.x + 1, actual.posicion.y));
			if(!visited.contains(derecha.posicion) && !walls.contains(derecha.posicion)){
				if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || grid[(int) derecha.posicion.x][(int) derecha.posicion.y].get(0).itype == 3){					
					derecha.accion = ACTIONS.ACTION_RIGHT;
					derecha.padre = actual;
					cola.add(derecha);
					visited.add(derecha.posicion);
				}
				
			}
		}
	}

	// Constructor
	public AgenteBFS(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){

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
		visited = new ArrayList<Vector2d>();
	}

	// Metodo act
	@Override
	public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
		ACTIONS accion = ACTIONS.ACTION_NIL;
		
		Node inicial = new Node();
		inicial.posicion = new Vector2d(avatar.x, avatar.y);

		Node objetivo = new Node();
		objetivo.posicion = new Vector2d(portal.x, portal.y);

		if(path.isEmpty()){
			BFS(inicial, objetivo);
			
			// La lista esta al reves, le damos la vuelta
			Collections.reverse(path);
			
			System.out.println("path: " + path);
			System.out.println("Tamaño de la path: " + path.size());
			System.out.println("Tiempo de cálculo: " + elapsedTimer);
			System.out.println("Nodos expandidos: " + nodosExpandidos);
			System.out.println("Nodos en memoria: " + visited.size());
		}
		
		accion = path.remove(0);
		return accion;
	}
}