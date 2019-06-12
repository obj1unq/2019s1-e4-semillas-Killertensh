class Planta {

	var property anioObtencion = null
	var property altura = null

   method esParcelaIdeal(parcela)
    
	method hrsDeSolToleradas()

	method esFuerte() {
		return self.hrsDeSolToleradas() > 10
	}

	method daSemillasNuevas() {
		return self.esFuerte() // Hago override para agregar la segunda condicion en cada clase
	}

	method espacioOcupado()

}




class Menta inherits Planta {

	override method hrsDeSolToleradas() = 6

	override method daSemillasNuevas() = self.esFuerte() or self.altura() > 0.4

	override method espacioOcupado() = self.altura() * 3

    override method esParcelaIdeal(parcela) = parcela.superficie() > 6
}

class HierbaBuena inherits Menta {

	override method espacioOcupado() = (self.altura() * 3) * 2

}





class Soja inherits Planta {

	override method hrsDeSolToleradas() {
		if (self.altura() < 0.5) {
			return 6
		} else if (self.altura().between(0.5, 1)) {
			return 7
		} else return 9
	}

	override method daSemillasNuevas() {
		return self.esFuerte() or (self.anioObtencion() > 2007 and self.altura() > 1)
	}

	override method espacioOcupado() = self.altura() / 2
	
	override method esParcelaIdeal(parcela) = parcela.hrsDeSolAlDia() == self.hrsDeSolToleradas()

}

class SojaTransgenica inherits Soja {

	override method daSemillasNuevas() = false
	
	override method esParcelaIdeal(parcela) = parcela.cantMaxDePlantas() == 1

}






class Quinoa inherits Planta {

	var hrsDeSolToleradas

	override method hrsDeSolToleradas() = hrsDeSolToleradas

	override method espacioOcupado() = 0.5

	override method daSemillasNuevas() = self.esFuerte() or self.anioObtencion() < 2009
 
    override method esParcelaIdeal(parcela) = !parcela.plantas().any({planta => planta.altura() > 1.5})
    
}




class Parcela {
	var property ancho = null
	var property largo = null
	var property hrsDeSolAlDia = null
	var property plantas = []
	
	method superficie() = self.ancho() * self.largo()
	
	method cantMaxDePlantas(){
		if (self.ancho() > self.largo()){return self.superficie() / 5}
		else return (self.superficie()/3) + self.largo()
	}
	
	method seAsociaBienA(unaPlanta) = null /*Lo defino en la clase correspondiente */
	
	method tieneComplicaciones() = 
	    plantas.any({planta => planta.hrsDeSolToleradas() < self.hrsDeSolAlDia()})
	    
	
	method sePuedePlantar(unaPlanta) = 
	    plantas.size() < self.cantMaxDePlantas() or unaPlanta.hrsDeSolToleradas() + 2 < self.hrsDeSolAlDia()
	
	method validarSiSePuedePlantar(unaPlanta){
		if (!self.sePuedePlantar(unaPlanta)){
			self.error("No se puede sembrar la planta")
		}
	}
	
	method plantarUnaPlanta(unaPlanta) {
		self.validarSiSePuedePlantar(unaPlanta)
		plantas.add(unaPlanta)
		
	}
	
	method cantPlantas() = 
	     plantas.size()
	
	method cantPlantasBienAsociadas() = 
	     plantas.count({planta => self.seAsociaBienA(planta)})    
	     
	
		
	
	     
	method porcentajeDePlantasBienAsociadas() =
	     (self.cantPlantasBienAsociadas() * 100) / plantas.size()
	          
	
}




class ParcelaEcologica inherits Parcela{
	
    override 	method seAsociaBienA(unaPlanta) = !self.tieneComplicaciones() and unaPlanta.esParcelaIdeal(self)
}


class ParcelaIndustrial inherits Parcela{
	
	override    method seAsociaBienA(unaPlanta) = self.plantas().size() <= 2 and unaPlanta.esFuerte()
}




object inta{
	var property parcelas = []
	

	
	method cantTotalDePlantas() {
	    var plantasTotales = 0
	    return   parcelas.foreach({parcela => plantasTotales += parcela.cantPlantas()})
	 } 
	 
	method cantPromedioPlantas(){
		return self.cantTotalDePlantas() / parcelas.size()
	} 
	     
	method parcelasConMasDe4Plantas() =
	     parcelas.filter({parcela => parcela.cantPlantas() > 4 })  
	     
	        
	     
	method parcelaMasAutoSustentable() = 
		self.parcelasConMasDe4Plantas().max({parcela => parcela.porcentajeDePlantasBienAsociadas()})
	   
}