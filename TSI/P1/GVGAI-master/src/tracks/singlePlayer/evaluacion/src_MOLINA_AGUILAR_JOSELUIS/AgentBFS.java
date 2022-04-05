package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import core.player.AbstractPlayer;
import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Stack;
import java.util.Vector;

import javax.swing.Action;



public class AgentBFS extends AbstractPlayer{

    public static ArrayList<ACTIONS> actions;
    private ArrayList<Observation>[][] obv;



    public AgentBFS(StateObservation so, ElapsedCpuTimer elapsedTimer) {
		actions = so.getAvailableActions();
	}

    public ArrayList<ACTIONS> BFS (Vector2d destino, StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        
        Queue<ACTIONS> path = new ArrayDeque<ACTION>();
        Node curr = null;
        PriorityQueue<Node> cola = new PriorityQueue<Node>();
        cola.add(curr);
        obv = stateObs.getObservationGrid();
        while(!cola.isEmpty()){
            Node exp;
            exp = cola.peek();
           
        }

        return path;
    }


    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
       Vector2d salida = this.calcularSalida(stateObs);
       System.out.println(salida);
        ACTIONS a = null;
        return a;
    }

    public Vector2d calcularSalida(StateObservation stateObs){
        Vector2d salida,fescala;

        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length , 
        stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);      
        //Buscar las posiciones de las meta
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());
        salida = posiciones[0].get(0).position;
        salida.x = Math.floor(salida.x / fescala.x);
        salida.y = Math.floor(salida.y / fescala.y);
        //System.out.println(salida);

        return salida;
    }

    
}
