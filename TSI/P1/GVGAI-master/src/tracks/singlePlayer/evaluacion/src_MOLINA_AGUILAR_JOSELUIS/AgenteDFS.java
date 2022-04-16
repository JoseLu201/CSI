package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS.Vector2D;

public class AgenteDFS extends AbstractPlayer {

	

    Vector2D avatar; 	//Posicion del avatar
	Vector2D fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta

	ArrayList<ACTIONS> path;
	ArrayList<Observation> grid[][];
	HashMap<Vector2D, Boolean> visited;
	
	// Parametros a medir
	int nodosExpandidos = 0;

	// Struct nodo
	public static class Node {
		public Vector2D posicion;
		public ACTIONS accion;
		public Node padre;

		@Override
    	public int hashCode() {
        return Objects.hash(posicion);
    }

		public Node() {
			posicion = new Vector2D();
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
                "Posicion : " + posicion.toString() +
                "Accion : " + accion.toString()
            );
        
	    }
    }

    void DFS(Node inicial, Node objetivo)  {
        if(!visited.containsKey(inicial.posicion)){
            visited.put(inicial.posicion,true);
        }
        DFS_search(inicial, objetivo);
    }

    void DFS_search(Node current, Node objetivo) {
        if(current.posicion.equals(objetivo.posicion)){
            while(current.padre != null){
                //Reconstruyo la path pero al reves

                path.add(current.accion);
                current = current.padre;
            }
        }else{
            
			nodosExpandidos++;
			// Casilla arriba
			Node arriba = new Node(new Vector2D(current.posicion.x, current.posicion.y - 1));
			if(!visited.containsKey(arriba.posicion)){
				if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(objetivo.posicion)){
					arriba.accion = ACTIONS.ACTION_UP;
					arriba.padre = current;
					visited.put(arriba.posicion,true);
                    DFS_search(arriba, objetivo);
				}
			}
			
			// Casilla abajo
			Node abajo = new Node(new Vector2D(current.posicion.x, current.posicion.y + 1));
			if(!visited.containsKey(abajo.posicion)){
				if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(objetivo.posicion)){
					abajo.accion = ACTIONS.ACTION_DOWN;
					abajo.padre = current;
					visited.put(abajo.posicion,true);
                    DFS_search(abajo, objetivo);
				}
			}
			
			// Casilla izquierda
			Node izquierda = new Node(new Vector2D(current.posicion.x - 1, current.posicion.y));

			if(!visited.containsKey(izquierda.posicion) ){
				if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(objetivo.posicion)){
					izquierda.accion = ACTIONS.ACTION_LEFT;
					izquierda.padre = current;
					visited.put(izquierda.posicion,true);
                    DFS_search(izquierda, objetivo);
				}
			}
			
			// Casilla derecha
			Node derecha = new Node(new Vector2D(current.posicion.x + 1, current.posicion.y));
			if(!visited.containsKey(derecha.posicion)){
				if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() ||  derecha.posicion.equals(objetivo.posicion)){					
					derecha.accion = ACTIONS.ACTION_RIGHT;
					derecha.padre = current;
					visited.put(derecha.posicion,true);
                    DFS_search(derecha, objetivo);
				}
			}
		}
    }

    public AgenteDFS(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
		fescala = new Vector2D(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
				stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

		ArrayList<Observation>[] portales = stateObs.getPortalsPositions();
		portal = portales[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		avatar =  new Vector2D(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);

		path = new ArrayList<ACTIONS>();
		grid = stateObs.getObservationGrid();

		visited = new HashMap<Vector2D, Boolean>();
	}

    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        ACTIONS accion = ACTIONS.ACTION_NIL;
		
		Node inicial = new Node();
		inicial.posicion = new Vector2D(avatar.x, avatar.y);

		Node objetivo = new Node();
		objetivo.posicion = new Vector2D(portal.x, portal.y);

		if(path.isEmpty()){
			DFS(inicial, objetivo);
			
			// La lista esta al reves, le damos la vuelta
			Collections.reverse(path);
			
			//System.out.println("path: " + path);
			System.out.println("Tamaño de la path: " + path.size());
			System.out.println("Tiempo de cálculo: " + elapsedTimer);
			System.out.println("Nodos expandidos: " + nodosExpandidos);
			System.out.println("Nodos en memoria: " + visited.size());
		}
		
		accion = path.remove(0);
		return accion;
    }
    
}
