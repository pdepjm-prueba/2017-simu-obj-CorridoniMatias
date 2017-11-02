class Empleado
{
	var stamina
	var tareasRealizadas = []
	var rol
	
	constructor(_rol)
	{
		rol = _rol
	}
	
	method experiencia()
	{
		
	}
	
	method hacerTarea(tarea)
	{
		tareasRealizadas.add(tarea)
	}
	
	method stamina() = stamina
	
	//Considere crear un objeto para cada fruta pero no tiene sentido ya que se puede pasar un valor directamente
	// y hacer un objeto no aporta nada ya que la fruta solo tendria el valor de stamina que agrega
	method comerFruta(cantidad)
	{
		stamina += cantidad	
	}
	
	method reducirStamina(cantidad)
	{
		stamina = 0.max(stamina - cantidad)
	}
	
	method tieneHerramientas(_htas)
	{
		return rol.tieneHerramientas(_htas)
	}
	
	method puedeDefender() = rol.puedeDefender()
	
	method fuerzaSegunRol() = rol.fuerza()
	
	method fuerza()
	{
		return stamina / 2 + 2 + self.fuerzaSegunRol()
	}
	
	
}

class ExcesoDeStaminaException inherits Exception{}

class Biclope inherits Empleado
{
	override method comerFruta(cantidad)
	{
		if(stamina + cantidad > 10)
			throw new ExcesoDeStaminaException()
			
		super(cantidad)
	}
}

class Ciclope inherits Empleado
{
	override method fuerza()
	{
		return super() / 2
	}
}

class Soldado
{
	var practicaArma = 0
	
	method fuerza()
	{
		return practicaArma
	}
	
	method usarArma()
	{
		practicaArma += 2
	}
	
	method tieneHerramientas(_htas)
	{
		return false
	}
	
	method puedeDefender() = true
}

class Mucama
{
	method fuerza()
	{
		return 0
	}
	
	method tieneHerramientas(_htas)
	{
		return false
	}
	
	method puedeDefender() = false
}

class Obrero
{
	var herramientas = #{}
	
	method fuerza()
	{
		return 0
	}
	
	method puedeDefender() = true
	
	method tieneHerramientas(_htas)
	{
		return herramientas.all({hta => _htas.contains(hta)})
	}
}


class HerramientasInsuficientesException inherits Exception{}

class StaminaMuyBajaException inherits Exception{}

class ArreglarMaquina
{
	var complejidad
	var herramientas = #{}
	
	constructor(_complejidad, _htasNecesarias)
	{
		complejidad = _complejidad
		herramientas = _htasNecesarias
	}
	
	method hacerTarea(trabajador)
	{
		if(trabajador.stamina() < complejidad)
			throw new StaminaMuyBajaException()
			
		if(!herramientas.isEmpty()) //Pongo este if porque si no tiene herramientas los soldados y mucamas deberian poder arreglar
			if(!trabajador.tieneHerramientas(herramientas))
				throw new HerramientasInsuficientesException()
			
		trabajador.reducirStamina(complejidad)
	}
	
	method dificultad()
	{
		return 2 * complejidad
	}
}


class NoPuedeDefenderException inherits Exception {}
class NoTieneSuficienteFuezaException inherits Exception {}

class DefenederSector{
	var gradoAmenaza 
	
	constructor(_gradoAmenaza)
	{
		gradoAmenaza = _gradoAmenaza	
	}
	
	method hacerTarea(trabajador)
	{
		if(!trabajador.puedeDefender())
			throw new NoPuedeDefenderException()
			
		if(trabajador.fuerza() < gradoAmenaza)
			throw new NoTieneSuficienteFuezaException()
			
		trabajador.reducirStamina(complejidad)
	}
	
	method dificultad()
	{
		return gradoAmenaza
	}
}





