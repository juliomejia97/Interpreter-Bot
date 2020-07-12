package co.edu.javeriana.bot.interpreter;

import java.util.List;
import java.util.Map;

public class Invoc_Function implements ASTNode {
	private String nombre;
	private List<String> parametros;
	private List<ASTNode> valorParam;
	private List<ASTNode> body;
	private Map<String, Object> tablaFuncion;
	
	
	
	public Invoc_Function(String nombre, List<ASTNode> valorParam) {
		super();
		this.nombre = nombre;
		this.valorParam = valorParam;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		tablaFuncion = (Map<String, Object>) symbolTable.get(nombre);
		parametros = (List<String>) tablaFuncion.get("parametros");
		body = (List<ASTNode>) tablaFuncion.get("body");
		for(int i=0; i<parametros.size(); i++) {
			tablaFuncion.put(parametros.get(i), valorParam.get(i).execute(tablaFuncion));
		}
		for(ASTNode n: body) {
			n.execute(tablaFuncion);
		}
		return null;
	}

}
