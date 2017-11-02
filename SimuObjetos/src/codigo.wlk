class Empleado
{
	var stamina
	var tareasRealizadas = []
	var rol
	
	constructor(_rol, _stamina)
	{
		rol = _rol
		stamina = _stamina
	}
	
	method multiplicadorDificultad()
	
	method reducirEstaminaPorDefender()
	{
		self.reducirStamina(rol.estaminaPorDefender(stamina))
	}
	
	method reducirEstaminaPorLimpiar(staminaUsada)
	{
		self.reducirStamina(rol.estaminaPorLimpiar(stamina, staminaUsada))
	}
	
	method puedeLimiparSiempre() = rol.puedeLimiparSiempre()
	
	
	method experiencia()
	{
		return self.cantidadDeTareas() + tareasRealizadas.sum({tarea => tarea.dificultad(self)})
	}
	
	method cantidadDeTareas() = tareasRealizadas.size()
	
	method hacerTarea(tarea)
	{
		tareasRealizadas.add(tarea)
		tarea.hacerTarea(self)
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
	
	override method multiplicadorDificultad()
	{
		return 1
	}
}

class Ciclope inherits Empleado
{
	override method fuerza()
	{
		return super() / 2
	}
	
	override method multiplicadorDificultad()
	{
		return 2
	}
}

class Rol
{
	method fuerza()
	{
		return 0
	}
	
	method tieneHerramientas(_htas)
	{
		return false
	}
	
	method estaminaPorDefender(estamina)
	{
		return estamina / 2
	}
	
	method estaminaPorLimpiar(estamina, estaminaUsada)
	{
		return estaminaUsada
	}
	
	method puedeLimiparSiempre() = false
	
	method puedeDefender() = true
}

class Soldado inherits Rol
{
	var practicaArma = 0
	
	override method fuerza()
	{
		return practicaArma
	}
	
	override method estaminaPorDefender(estamina)
	{
		return 0
	}
	
	method usarArma()
	{
		practicaArma += 2
	}
	
	override method puedeDefender() = true
}

class Mucama inherits Rol
{
	override method puedeLimiparSiempre() = true
	
	override method estaminaPorLimpiar(estamina, estaminaUsada)
	{
		return 0
	}
}

class Obrero inherits Rol
{
	var herramientas = #{}
	
	override method tieneHerramientas(_htas)
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
	
	method dificultad(empleado)
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
			
		trabajador.reducirEstaminaPorDefender()
	}
	
	method dificultad(empleado)
	{
		return gradoAmenaza * empleado.multiplicadorDificultad()
	}
}

class LimpiarSector{
	var dificultad = 10 
	
	var staminaRequerida = 1
	
	constructor(esGrande)
	{
		if(esGrande)
			staminaRequerida = 4
	}
	
	method hacerTarea(trabajador)
	{
		if(!trabajador.puedeLimpiarSiempre())
			if(trabajador.stamina() < staminaRequerida)
				throw new StaminaMuyBajaException()
			
		trabajador.reducirEstaminaPorLimpiar(staminaRequerida)
	}
	
	method actualizarDificultad(_dif)
	{
		dificultad = _dif	
	}
	
	method dificultad(empleado)
	{
		return dificultad
	}
}






