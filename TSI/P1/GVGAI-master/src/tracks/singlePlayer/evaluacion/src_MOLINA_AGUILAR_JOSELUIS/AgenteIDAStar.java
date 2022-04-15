package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.PriorityQueue;

import javax.swing.Action;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

public class AgenteIDAStar  extends AbstractPlayer{
    
    Vector2d avatar; 	//Posicion del avatar
	Vector2d fescala; 	//Escala pix grid
	Vector2d portal;	//Salida/meta
	
	ArrayList<ACTIONS> path;
	ArrayList<Observation> grid[][];

    int nodosMemoria = 0;
    int nodosExpandidos = 0;

    Node solucion;

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
        LinkedHashMap<Vector2d, Node> ruta = new LinkedHashMap<>();
		Node inicial = new Node(inicio);
		Node solucion = inicial;
		int cota = inicial.g;
		ruta.put(inicial.posicion, inicial);

		while(true){
			var resultado = IDA_search(ruta, 0, cota,fin);

			// Si el resultado es un numero negativo se ha encontrado solución
			if (resultado < 0){
				Vector2d lastElementKey = new ArrayList<>(ruta.keySet()).get(ruta.size() - 1);
				solucion = ruta.get(lastElementKey);

                while(solucion.padre != null){
                    path.add(solucion.accion);
                    solucion = solucion.padre;
                }

				nodosMemoria = path.size();
				//return path;
			}

			// Si el resultado es infinito se ha terminado el algoritmo y no hay solucion
			if (resultado == Double.POSITIVE_INFINITY)
				throw new ArithmeticException("No se ha encontrado solución");

			// Se actualiza la cota
			cota = resultado;
		}


    }

    public int IDA_search(LinkedHashMap<Vector2d, Node> ruta, int g, int cota,Node fin)
	{
		// Se toma como nodo actual el último elemento de la ruta
		Vector2d lastElementKey = new ArrayList<>(ruta.keySet()).get(ruta.size() - 1);
		var current = ruta.get(lastElementKey);

		// Se calcula el coste del nodo y, si sobrepasa la cota, se devuelve y no se
		// continua explorando la ruta actual
		int f = g + current.h;
		if (f > cota) { return f; }

		// Si el nodo actual es objetivo el algoritmo ha terminado
		nodosExpandidos += 1;
		if (current.posicion.equals(portal)) { solucion = current; return -1; }

		// Se expande del nodo actual
		var min = Double.POSITIVE_INFINITY;

/////////////////////////////////////////////

        Node arriba = new Node(new Vector2d(current.posicion.x, current.posicion.y -1));
			
				//SOLO ANDO SI HAY SUELO O META
			if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(fin.posicion)){				
				// Si el nodo no ha sido visitado en la ruta actual 
                if(current.padre != null){
                    if(!arriba.posicion.equals(current.padre.posicion)){
                        if(!ruta.containsKey(arriba.posicion)){
                            // Se incluye a la ruta y se llama a la función de forma recursiva sobre
                            // la nueva ruta
                            ruta.put(arriba.posicion, arriba);
                            var t = IDA_search(ruta, g+1, cota,fin);
                            // Si devuelve negativo es porque se ha encontrado solución y se propaga
                            if (t < 0)
                                return t;

                            // Se actualiza el coste mínimo
                            if (t < min)
                                min = t;

                            // Se elimina el nodo de la ruta para probar con otro vecino
                            ruta.remove(arriba.posicion);
                        }
                    }
                }
			}
            Node abajo =  new Node(new Vector2d(current.posicion.x, current.posicion.y +1));
			
				//SOLO ANDO SI HAY SUELO O META
                if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(fin.posicion)){				
                    // Si el nodo no ha sido visitado en la ruta actual 
                    if(current.padre != null){
                        if(!abajo.posicion.equals(current.padre.posicion)){
                            if(!ruta.containsKey(abajo.posicion)){
                                // Se incluye a la ruta y se llama a la función de forma recursiva sobre
                                // la nueva ruta
                                ruta.put(abajo.posicion, abajo);
                                var t = IDA_search(ruta, g+1, cota,fin);
                                // Si devuelve negativo es porque se ha encontrado solución y se propaga
                                if (t < 0)
                                    return t;
    
                                // Se actualiza el coste mínimo
                                if (t < min)
                                    min = t;
    
                                // Se elimina el nodo de la ruta para probar con otro vecino
                                ruta.remove(abajo.posicion);
                            }
                        }
                    }
                }

            Node izquierda = new Node(new Vector2d(current.posicion.x+1, current.posicion.y ));
			
				//SOLO ANDO SI HAY SUELO O META
                if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(fin.posicion)){				
                    // Si el nodo no ha sido visitado en la ruta actual 
                    if(current.padre != null){
                        if(!izquierda.posicion.equals(current.padre.posicion)){
                            if(!ruta.containsKey(izquierda.posicion)){
                                // Se incluye a la ruta y se llama a la función de forma recursiva sobre
                                // la nueva ruta
                                ruta.put(izquierda.posicion, izquierda);
                                var t = IDA_search(ruta, g+1, cota,fin);
                                // Si devuelve negativo es porque se ha encontrado solución y se propaga
                                if (t < 0)
                                    return t;
    
                                // Se actualiza el coste mínimo
                                if (t < min)
                                    min = t;
    
                                // Se elimina el nodo de la ruta para probar con otro vecino
                                ruta.remove(izquierda.posicion);
                            }
                        }
                    }
                }

            Node derecha = new Node(new Vector2d(current.posicion.x, current.posicion.y -1));
			
				//SOLO ANDO SI HAY SUELO O META
                if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(fin.posicion)){				
                    // Si el nodo no ha sido visitado en la ruta actual 
                    if(current.padre != null){
                        if(!derecha.posicion.equals(current.padre.posicion)){
                            if(!ruta.containsKey(derecha.posicion)){
                                // Se incluye a la ruta y se llama a la función de forma recursiva sobre
                                // la nueva ruta
                                ruta.put(derecha.posicion, derecha);
                                var t = IDA_search(ruta, g+1, cota,fin);
                                // Si devuelve negativo es porque se ha encontrado solución y se propaga
                                if (t < 0)
                                    return t;
    
                                // Se actualiza el coste mínimo
                                if (t < min)
                                    min = t;
    
                                // Se elimina el nodo de la ruta para probar con otro vecino
                                ruta.remove(derecha.posicion);
                            }
                        }
                    }
                }






		return (int)min;
	}



    public AgenteIDAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
		fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
				stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

		ArrayList<Observation>[] portales = stateObs.getPortalsPositions();
		portal = portales[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);


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
			IDAStar(inicial, objetivo);
			
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
