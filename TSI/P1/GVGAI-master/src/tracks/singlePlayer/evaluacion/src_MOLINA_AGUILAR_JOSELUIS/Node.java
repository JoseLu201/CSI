package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;
import java.util.ArrayList;
import java.util.Set;

import core.game.ForwardModel;
import core.game.Game;
import core.game.StateObservation;
import ontology.Types.ACTIONS;
import tools.Vector2d;
import tools.pathfinder.Agent;


public class Node implements Comparable<Node>{
    private Node parent;
    private ArrayList<Node> childs;
    private Vector2d posicion;
    private Vector2d orientacion;
    private Vector2d portal;
    private double dist_obj;
    private double coste_camino;
    private double coste_total;
    private boolean visitado;
    private StateObservation state;
    private ArrayList<ACTIONS> availableActions;

    public Node(Vector2d pos, Vector2d portal,Vector2d orientacion, StateObservation state){
        this.posicion = pos;
        this.portal = portal;
        this.orientacion = orientacion;
        this.visitado = false;       
    }

    @Override
    public int compareTo(Node o) {
        if(coste_total < o.coste_total)
            return -1;
        if(coste_total > o.coste_total)
            return 1;
        if(coste_total == o.coste_total){
            if(dist_obj < o.dist_obj)
                return -1;
            if(dist_obj > o.dist_obj)
                return 1;
        }
        return 0;
    
    }

    public ArrayList<Node> expandirNodoBFS(Node n){
        ArrayList<Node> exp = new ArrayList<>();
        ArrayList<ACTIONS> availableActions = n.state.getAvailableActions();


        return exp;
    }

    public Vector2d getPosicion() {
        return this.posicion;
    }

    public void setPosicion(Vector2d posicion) {
        this.posicion = posicion;
    }

    public Vector2d getOrientacion() {
        return this.orientacion;
    }

    public void setOrientacion(Vector2d orientacion) {
        this.orientacion = orientacion;
    }

    public Vector2d getPortal() {
        return this.portal;
    }

    public void setPortal(Vector2d portal) {
        this.portal = portal;
    }

    public double getDist_obj() {
        return this.dist_obj;
    }

    public void setDist_obj(double dist_obj) {
        this.dist_obj = dist_obj;
    }

    public double getCoste_camino() {
        return this.coste_camino;
    }

    public void setCoste_camino(double coste_camino) {
        this.coste_camino = coste_camino;
    }

    public double getCoste_total() {
        return this.coste_total;
    }

    public void setCoste_total(double coste_total) {
        this.coste_total = coste_total;
    }

    public Node getParent() {
        return this.parent;
    }

    public void setParent(Node parent) {
        this.parent = parent;
    }

    public boolean isVisitado() {
        return this.visitado;
    }

    public boolean getVisitado() {
        return this.visitado;
    }

    public void setVisitado(boolean visitado) {
        this.visitado = visitado;
    }
           
}   
/*
public static void main(String[] args){
    Vector2d pos = new Vector2d(0, 0);
    Vector2d portal = new Vector2d(3, 3);
    Vector2d orientacion = new Vector2d(0, 0);
    Game a_gameState = new Game() {

        @Override
        public boolean isGameOver() {
            //return getGameWinner() != Types.WINNER.NO_WINNER;
        }

        @Override
        public void buildStringLevel(String[] levelString, int randomSeed) {
            // TODO Auto-generated method stub
            
        }
        
    };
    ForwardModel a_model = new ForwardModel(a_gameState, 1)
    StateObservation state = new StateObservation(a_model, 1)
    Node n = new Node(pos, portal, orientacion, state);
}*/