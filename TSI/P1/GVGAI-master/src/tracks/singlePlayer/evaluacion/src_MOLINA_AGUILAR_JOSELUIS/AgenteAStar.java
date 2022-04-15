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

	

		// NO TENGO QUE MIRAR SI EL HIJO ESTÁ EN CERRADOS PORQUE LA HEURÍSTICA (DISTANCIA MANHATTAN)
		// ES UNA HEURÍSTICA MONÓTONA Y POR TANTO NO HAY QUE COMPROBAR SI ESTÁ EN CERRADOS 
		// (VISTO Y DEMOSTRADO EN TEORÍA)

    public void AStar(Node inicio, Node fin){
        PriorityQueue<Node> abiertos = new  PriorityQueue<>();
		ArrayList<Node> cerrados = new ArrayList<Node>();
		abiertos.add(inicio);
		Node current = new Node();
		Node aux = new Node(new Vector2d(0,0));
		aux.g = 1;
		int iter = 0;
		while(true && !abiertos.isEmpty()){
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
			
				//SOLO ANDO SI HAY SUELO O META
			if(grid[(int) arriba.posicion.x][(int) arriba.posicion.y].isEmpty() || arriba.posicion.equals(fin.posicion)){				
				if(arriba.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !!");
				}else{
					boolean cerrados_contein = cerrados.contains(arriba);
					boolean abiertos_contein = abiertos.contains(arriba);
					arriba.h = distMH(arriba, fin);
					arriba.accion = ACTIONS.ACTION_UP;
					arriba.padre = current;
					arriba.g = g(arriba);
					arriba.CalcF();
					//System.out.println("->Arriba "+ arriba.toString());
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(arriba);
						//System.out.println("Entro3");
					}else{ 
						Node i = getElement(abiertos, arriba);
						//System.out.println("Nodo i " +i);
						if(abiertos_contein && i != null && arriba.g < i.g){
							//System.out.println("Actualizar nodo");
							abiertos.remove(i);
							abiertos.add(arriba);
						}
					}
				}
			}

			/*-------------------Abajo ------------------------*/
			Node abajo = new Node(new Vector2d(current.posicion.x, current.posicion.y +1));
			if(grid[(int) abajo.posicion.x][(int) abajo.posicion.y].isEmpty() || abajo.posicion.equals(fin.posicion)){
				if(abajo.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !! ");
					
				}else{
					boolean cerrados_contein = cerrados.contains(abajo);
					boolean abiertos_contein = abiertos.contains(abajo);
					abajo.h = distMH(abajo, fin);
					abajo.accion = ACTIONS.ACTION_DOWN;
					abajo.padre = current;
					abajo.g = g(abajo);
					abajo.CalcF();
					
					//System.out.println("->Abajo "+ abajo.toString());
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(abajo);
						//System.out.println("Entro3");
					}else{ 
						Node i = getElement(abiertos, abajo);
						//System.out.println("Nodo i " +i);
						if(abiertos_contein && i != null && abajo.g < i.g){
							//System.out.println("Actualizar nodo");
							abiertos.remove(i);
							abiertos.add(abajo);
						}
					}
				}
				
			}

			Node izquierda  = new Node(new Vector2d(current.posicion.x-1, current.posicion.y));
			izquierda.h = distMH(izquierda, fin);
			izquierda.accion = current.accion;
			
			izquierda.padre = current;
			izquierda.g = g(izquierda);
			izquierda.CalcF();
			if(grid[(int) izquierda.posicion.x][(int) izquierda.posicion.y].isEmpty() || izquierda.posicion.equals(fin.posicion)){
				
				
				if(izquierda.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !!");
				}else{
					boolean cerrados_contein = cerrados.contains(izquierda);
					boolean abiertos_contein = abiertos.contains(izquierda);
					izquierda.h = distMH(izquierda, fin);
					izquierda.accion = ACTIONS.ACTION_LEFT;
					izquierda.padre = current;
					izquierda.g = g(izquierda);
					izquierda.CalcF();
					//System.out.println("->Izquierda "+ izquierda.toString());

					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(izquierda);
						//System.out.println("Entro3");
					}else{ 
						Node i = getElement(abiertos, izquierda);
						//System.out.println("Nodo i " +i);
						if(abiertos_contein && i != null && izquierda.g < i.g){
							//System.out.println("Actualizar nodo");
							abiertos.remove(i);
							abiertos.add(izquierda);
						}
					}
				}
				
			}

			Node derecha = new Node(new Vector2d(current.posicion.x+1, current.posicion.y ));
			derecha.h = distMH(derecha, fin);
			derecha.accion = ACTIONS.ACTION_RIGHT;
			
			derecha.padre = current;
			derecha.g = g(derecha);
			derecha.CalcF();
			if(grid[(int) derecha.posicion.x][(int) derecha.posicion.y].isEmpty() || derecha.posicion.equals(fin.posicion)){
				
				
				if(derecha.posicion.equals(current.padre.posicion)){
					//System.out.println("Padre VISITADO !!");
				}else{
					boolean cerrados_contein = cerrados.contains(derecha);
					boolean abiertos_contein = abiertos.contains(derecha);
					derecha.h = distMH(derecha, fin);
					derecha.accion = ACTIONS.ACTION_RIGHT;
					
					derecha.padre = current;
					derecha.g = g(derecha);
					derecha.CalcF();
					//System.out.println("->Derecha "+ derecha.toString());
					if(!cerrados_contein && !abiertos_contein){
						abiertos.add(derecha);
						//System.out.println("Entro3");
					}else{ 
						Node i = getElement(abiertos, derecha);
						//System.out.println("Nodo i " +i);
						if(abiertos_contein && i != null && derecha.g < i.g){
							//System.out.println("Actualizar nodo");
							abiertos.remove(i);
							abiertos.add(derecha);
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
