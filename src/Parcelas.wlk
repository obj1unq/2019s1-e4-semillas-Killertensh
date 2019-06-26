import semillas.*

class Parcela {

	var property ancho = null
	var property largo = null
	var property hrsDeSolAlDia = null
	var property plantas = []

	method superficie() = self.ancho() * self.largo()

	method cantMaxDePlantas() {
		if (self.ancho() > self.largo()) {
			return self.superficie() / 5
		} else return (self.superficie() / 3) + self.largo()
	}

	method seAsociaBienA(unaPlanta) = null /*Metodo abstacto para ser definido en la subclase como corresponda */

	method tieneComplicaciones() = plantas.any({ planta => planta.hrsDeSolToleradas() < self.hrsDeSolAlDia() })

	method sePuedePlantar(unaPlanta) = plantas.size() < self.cantMaxDePlantas() or unaPlanta.hrsDeSolToleradas() + 2 < self.hrsDeSolAlDia()

	method validarSiSePuedePlantar(unaPlanta) {
		if (!self.sePuedePlantar(unaPlanta)) {
			self.error("No se puede sembrar la planta")
		}
	}

	method plantarUnaPlanta(unaPlanta) {
		self.validarSiSePuedePlantar(unaPlanta)
		plantas.add(unaPlanta)
	}

	method cantPlantas() = plantas.size()

	method cantPlantasBienAsociadas() = plantas.count({ planta => self.seAsociaBienA(planta) })

	method porcentajeDePlantasBienAsociadas() = (self.cantPlantasBienAsociadas() * 100) / plantas.size()

}

class ParcelaEcologica inherits Parcela {

	override method seAsociaBienA(unaPlanta) = !self.tieneComplicaciones() and unaPlanta.esParcelaIdeal(self)

}

class ParcelaIndustrial inherits Parcela {

	override method seAsociaBienA(unaPlanta) = self.plantas().size() <= 2 and unaPlanta.esFuerte()

}


object inta {

	var property parcelas = []

	method cantTotalDePlantas() {
		var plantasTotales = 0
		return parcelas.foreach({ parcela => plantasTotales += parcela.cantPlantas() })
	}

	method cantPromedioPlantas() {
		return self.cantTotalDePlantas() / parcelas.size()
	}

	method parcelasConMasDe4Plantas() = parcelas.filter({ parcela => parcela.cantPlantas() > 4 })

	method parcelaMasAutoSustentable() = self.parcelasConMasDe4Plantas().max({ parcela => parcela.porcentajeDePlantasBienAsociadas() })

}

