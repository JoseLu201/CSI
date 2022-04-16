package tracks.singlePlayer.evaluacion.src_MOLINA_AGUILAR_JOSELUIS;

import java.util.Objects;

import tools.Vector2d;


// Clase que abstrae a Vector2d y que implementa el método hashCode que permite
// usar la clase como clave en una tabla hash
public class Vector2D extends Vector2d{
	public Vector2D() {
		super();
	}

	public Vector2D(double x, double y) {
		super(x, y);
	}

	public Vector2D(Vector2D avatar) {
		super(avatar.x,avatar.y);
    }

    @Override
	public int hashCode() {
		return Objects.hash(x, y);
	}
}