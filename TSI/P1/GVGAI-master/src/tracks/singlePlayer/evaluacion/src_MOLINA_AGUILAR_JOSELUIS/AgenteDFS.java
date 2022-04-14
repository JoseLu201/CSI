package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

public class AgenteDFS extends AbstractPlayer {

    Vector2d avatar; 	//Posicion del avatar
	Vector2d fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta

	ArrayList<Vector2d> walls;
	ArrayList<ACTIONS> path;
	ArrayList<Observation> grid[][];
	ArrayList<Vector2d> visited;
	
	// Parametros a medir
	int nodosExpandidos = 0;

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
        public String toString(){
            return(
                "Posicion : " + posicion.toString() +
                "Accion : " + accion.toString()
            );
        
	    }
    }

    void DFS(Node inicial, Node objetivo){
        if(!visited.contains(inicial.posicion)){
            visited.add(inicial.posicion);
        }
        DFS_search(inicial, objetivo);
    }

    void DFS_search(Node current, Node objetivo){
        //System.out.println(current.toString());
        //System.out.println(grid[(int) current.posicion.x][(int) current.posicion.y].toString());
        if(current.posicion.equals(objetivo.posicion)){
            while(current.padre != null){
                //Reconstruyo la path pero al reves

                path.add(current.accion);
                current = current.padre;
            }
        }else{
            
			nodosExpandidos++;
			// Casilla arriba
			Node arriba = new Node(new Vector2d(current.posicion.x, current.posicion.y - 1));
			if(!visited.contains(arriba.posicion) && !walls.contains(arriba.posicion)){
				if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(objetivo.posicion)){
					arriba.accion = ACTIONS.ACTION_UP;
					arriba.padre = current;
					visited.add(arriba.posicion);
                    DFS_search(arriba, objetivo);

				}
			}
			
			// Casilla abajo
			Node abajo = new Node(new Vector2d(current.posicion.x, current.posicion.y + 1));
			if(!visited.contains(abajo.posicion) && !walls.contains(abajo.posicion)){
				if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(objetivo.posicion)){
					abajo.accion = ACTIONS.ACTION_DOWN;
					abajo.padre = current;
					visited.add(abajo.posicion);
                    DFS_search(abajo, objetivo);
				}
			}
			
			// Casilla izquierda
			Node izquierda = new Node(new Vector2d(current.posicion.x - 1, current.posicion.y));

			if(!visited.contains(izquierda.posicion) && !walls.contains(izquierda.posicion)){
				if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(objetivo.posicion)){
					izquierda.accion = ACTIONS.ACTION_LEFT;
					izquierda.padre = current;
					visited.add(izquierda.posicion);
                    DFS_search(izquierda, objetivo);
				}
			}
			
			// Casilla derecha
			Node derecha = new Node(new Vector2d(current.posicion.x + 1, current.posicion.y));
			if(!visited.contains(derecha.posicion) && !walls.contains(derecha.posicion)){
				if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(objetivo.posicion)){					
					derecha.accion = ACTIONS.ACTION_RIGHT;
					derecha.padre = current;
					visited.add(derecha.posicion);
                    DFS_search(derecha, objetivo);
				}
				
			}
		}
    }

    public AgenteDFS(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
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
/*        System.out.println("Avatar "+grid[(int) avatar.x][(int) avatar.y].toString());
        System.out.println("Portal "+grid[(int) portal.x][(int) portal.y].toString());
        System.out.println("Muro "+grid[(int) portal.x+1][(int) portal.y].toString());
        System.out.println("Nada "+grid[(int) portal.x-1][(int) portal.y].toString());
        System.out.println("Trampa  "+grid[(int) portal.x-2][(int) portal.y+1].toString());
*/
		visited = new ArrayList<Vector2d>();
	}

    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        ACTIONS accion = ACTIONS.ACTION_NIL;
		
		Node inicial = new Node();
		inicial.posicion = new Vector2d(avatar.x, avatar.y);

		Node objetivo = new Node();
		objetivo.posicion = new Vector2d(portal.x, portal.y);

		if(path.isEmpty()){
			DFS(inicial, objetivo);
			
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
