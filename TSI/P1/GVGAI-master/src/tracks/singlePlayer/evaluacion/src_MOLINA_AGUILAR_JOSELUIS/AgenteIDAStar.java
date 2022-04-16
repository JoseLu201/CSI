package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Stack;

import javax.swing.Action;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

public class AgenteIDAStar  extends AbstractPlayer{
    
    Vector2D avatar; 	//Posicion del avatar
	Vector2D fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta
	
	LinkedHashMap<Vector2D, Node> path = new LinkedHashMap<>();
	Queue<ACTIONS> ansPath =  new LinkedList<>();
	ArrayList<Observation> grid[][];

    int nodosMemoria = 0;
    int nodosExpandidos = 0;

    Node solucion;

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
		public Object getPos() {
			return posicion;
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

	public Node getElement(final PriorityQueue<Node> cola, Node ele){
		PriorityQueue<Node> aux = new PriorityQueue<>(cola);
		Node ans = new Node();
		boolean found = false;
		while(!aux.isEmpty() && !found){
			ans = aux.remove();
			if(ans.equals(ele)){
				found = true;
				return ans;
			}
		}
		return null;
	}


    public void IDAStar(Node inicio, Node fin){
        
		Node inicial = new Node(inicio);
		Node solucion = inicial;
		int cota = inicial.h;
		path.put(inicial.posicion, inicial);
		Node aux = new Node(new Vector2D(0,0));
		aux.g = 1;

		while(true){
			
			solucion.padre = aux;
			int t = IDA_search(path, 0, cota,fin);
			if (t < 0){
				Vector2D currKey = new ArrayList<>(path.keySet()).get(path.size() - 1);
				solucion = path.get(currKey);
				Node reconstSol = solucion;
				while(reconstSol.padre != null){
					ansPath.add(reconstSol.accion);
					reconstSol = reconstSol.padre;
				}
				nodosMemoria = path.size();
				return;
			}
			if (t == Double.POSITIVE_INFINITY){
				throw new ArithmeticException("No se ha encontrado solución");
			}
			cota = t;
		}


    }

    public int IDA_search(LinkedHashMap<Vector2D, Node> path, int g, int cota,Node fin){
		// Se toma como nodo actual el último elemento de la ruta
		Vector2D currKey = new ArrayList<>(path.keySet()).get(path.size() - 1);
		Node current = path.get(currKey);

		// Se calcula el coste del nodo y, si sobrepasa la cota, se devuelve y no se
		// continua explorando la ruta actual
		int f = g + current.h;
		if (f > cota){ 
			return f;
		}
		nodosExpandidos++;
		// Si el nodo actual es objetivo el algoritmo ha terminado	
		if (current.posicion.equals(fin.posicion)) { solucion = current; return -1; }

		// Se expande del nodo actual
		var min = Double.POSITIVE_INFINITY;

		//Vector donde ordeno los sucesores del nodo actual
		ArrayList<Node> vecinos = new ArrayList<>();
		Node arriba = new Node(new Vector2D(current.posicion.x, current.posicion.y -1));
		if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(fin.posicion)){				
			if(current.padre != null){
				if(!arriba.posicion.equals(current.padre.posicion)){
					if(!path.containsKey(arriba.posicion)){
						arriba.h = distMH(arriba, fin);
						arriba.accion = ACTIONS.ACTION_UP;
						arriba.padre = current;
						arriba.g = g(arriba);
						arriba.CalcF();
						vecinos.add(arriba);
					}
				}
			}
		}

        Node abajo =  new Node(new Vector2D(current.posicion.x, current.posicion.y+1));
		if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(fin.posicion)){				
			if(current.padre != null){
				if(!abajo.posicion.equals(current.padre.posicion)){
					if(!path.containsKey(abajo.posicion)){
						abajo.h = distMH(abajo, fin);
						abajo.accion = ACTIONS.ACTION_DOWN;
						abajo.padre = current;
						abajo.g = g(abajo);
						abajo.CalcF();
						vecinos.add(abajo);
					}	
				}
			}
		}
			
        Node izquierda = new Node(new Vector2D(current.posicion.x-1, current.posicion.y ));
		if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(fin.posicion)){				
			if(current.padre != null){
				if(!izquierda.posicion.equals(current.padre.posicion)){
					if(!path.containsKey(izquierda.posicion)){
						izquierda.h = distMH(izquierda, fin);
						izquierda.accion = ACTIONS.ACTION_LEFT;
						izquierda.padre = current;
						izquierda.g = g(izquierda);
						izquierda.CalcF();
						vecinos.add(izquierda);
					}
				}
			}
		}

		Node derecha = new Node(new Vector2D(current.posicion.x+1, current.posicion.y ));			
		if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(fin.posicion)){
			if(current.padre != null){
				if(!derecha.posicion.equals(current.padre.posicion)){
					if(!path.containsKey(derecha.posicion)){
						derecha.h = distMH(derecha, fin);
						derecha.accion = ACTIONS.ACTION_RIGHT;
						derecha.padre = current;
						derecha.g = g(derecha);
						derecha.CalcF();
						vecinos.add(derecha);
					}
				}
			}
		}


		Collections.sort(vecinos, new Comparator<Node>() {
			public int compare(Node o1, Node o2){
     			return o1.compareTo(o2);
  			}
		});

		for(Node n : vecinos){
			if(!path.containsKey(n.posicion)){
				path.put(n.posicion, n);
				var t = IDA_search(path, g+1, cota,fin);
				if (t < 0)
					return t;
				// Se actualiza el coste mínimo
				if (t < min)
					min = t;
				path.remove(n.posicion);
			}
		}
	
		return (int)min;
			
	}



    public AgenteIDAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
		fescala = new Vector2D(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
				stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

		ArrayList<Observation>[] portales = stateObs.getPortalsPositions();
		portal = portales[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		avatar =  new Vector2D(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);



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

		if(ansPath.isEmpty()){
			IDAStar(inicial, objetivo);
			
			Collections.reverse((List<?>) ansPath);
			ansPath.remove(); //El primer es nil
			
			System.out.println("path: " + ansPath);
			System.out.println("Tamaño de la path: " + ansPath.size());
			System.out.println("Tiempo de cálculo: " + elapsedTimer);
			System.out.println("Nodos expandidos: " + nodosExpandidos); 
			System.out.println("Nodos en memoria: " + nodosMemoria);
		}
		
		accion = ansPath.remove();
		return accion;
    }
    
}
