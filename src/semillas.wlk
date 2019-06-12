import Parcelas.*


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

	override method esParcelaIdeal(parcela) = !parcela.plantas().any({ planta => planta.altura() > 1.5})

}



