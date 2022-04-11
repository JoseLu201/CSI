package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import core.player.AbstractPlayer;
import core.game.Game;
import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import ontology.Types.ACTIONS;
import tools.Direction;
import tools.ElapsedCpuTimer;
import tools.Utils;
import tools.Vector2d;
import tools.pathfinder.PathFinder;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Stack;
import java.util.Vector;

import javax.swing.Action;




/*
public class AgentBFS extends AbstractPlayer{

    public static ArrayList<ACTIONS> actions;
    private ArrayList<Observation>[][] obv;



    public AgentBFS(StateObservation so, ElapsedCpuTimer elapsedTimer) {
		actions = so.getAvailableActions();
	}

    public ArrayList<ACTIONS> BFS (Node ini, Node fin,Vector2d destino, StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        ArrayList<ACTIONS> path = new ArrayList<>();
        path.add( ACTIONS.ACTION_DOWN );
        Queue<Node> cola = new LinkedList<>();
        ini.setVisitado(true);
        ini.setParent(null);
        cola.add(ini);
        Node curr = null;
        while(!cola.isEmpty()){
            curr = cola.peek();
            if(curr.getPosicion() == destino){
                //return;
            }
            //Genero todos los sucesores de u
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

    
}*/

public class Agent extends AbstractPlayer
{
    protected PathFinder pathf;

    /**
     * Public constructor with state observation and time due.
     * @param so state observation of the current game.
     * @param elapsedTimer Timer for the controller creation.
     */
    public Agent(StateObservation so, ElapsedCpuTimer elapsedTimer)
    {
        ArrayList<Integer> list = new ArrayList<>(0);
        list.add(0); //wall
        pathf = new PathFinder(list);
        pathf.run(so);
        
    }

    /**
     * Picks an action. This function is called every game step to request an
     * action from the player.
     * @param stateObs Observation of the current state.
     * @param elapsedTimer Timer when the action returned is due.
     * @return An action for the current state
     */
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer)
    {
        Direction move = Utils.processMovementActionKeys(Game.ki.getMask(), Types.DEFAULT_SINGLE_PLAYER_KEYIDX); //use primary set of keys, idx = 0
        boolean useOn = Utils.processUseKey(Game.ki.getMask(), Types.DEFAULT_SINGLE_PLAYER_KEYIDX); //use primary set of keys, idx = 0

        Types.ACTIONS action = Types.ACTIONS.fromVector(move);
        if(action == Types.ACTIONS.ACTION_NIL && useOn)
            action = Types.ACTIONS.ACTION_USE;

        return action;
    }
}
