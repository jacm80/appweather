require 'rubygems'
require 'sinatra'
require 'json'
require 'rest-client'

#before do
#	puts "Filtro procesado!"
#end 

=begin
	
Pagina principal para seleccionar la ciudad
	
=end

get '/' do
	@ciudades = [:'Buenos Aires',:'Lima',:'Santiago de Chile',:'New York',:'Toronto']
	erb :index
end 

=begin
	
Metodo que recibe el parametro ciudad, se conecta al servicio 
y parsea un JSON y desplega ua ficha con la informacion del tiempo
quedo pendiente traducir la informacion del tiempo, ya que tiene una 
serie de items, y para traducirlo habria que hacer un diccionario
lo bastante extenso o conseguir una api en espanol.
	
=end

post '/pronostico' do
	param = CGI.escape(params[:ciudad])
	#---------------------------------
	f = Time.new
	dia_esp = {'Monday'=>'Lunes','Tuesday'=>'Martes','Wednesday'=>'Miercoles',
			   'Thursday'=>'Jueves','Friday'=>'Viernes','Saturday'=>'Sabado','Sunday'=>'Domingo'}

	hora   = f.strftime("%H:%M:%S")
	fecha  = f.strftime("%d/%m/%Y")
	dia    = dia_esp[f.strftime("%A")]
	#---------------------------------
	@fecha = "#{dia}: #{fecha} Hora: #{hora}"
	@ciudad = params[:ciudad].upcase
	#-------------------------------------------------------------------------------------------------
	response = RestClient.get "http://api.openweathermap.org/data/2.5/weather?q=#{param}&units=metric"
	#-------------------------------------------------------------------------------------------------
	root    = JSON.parse(response)
	weather = root["weather"]
	@clima_main        = root["weather"][0]["main"]
	@clima_descripcion = root["weather"][0]["description"]
	@temperatura	   = root["main"]["temp"]
	@presion	   	   = root["main"]["pressure"]
	@humedad	   	   = root["main"]["humidity"]
	@temp_min	   	   = root["main"]["temp_min"]
	@temp_max		   = root["main"]["temp_max"]
	@viento			   = "velocidad #{root["wind"]["speed"]} km/seg | grados: #{root["wind"]["deg"]} °"
	@img 			   = "#{root["weather"][0]["icon"]}.png"
	#-------------------------------------------------------------------------------------------------
	erb :pronostico
end

=begin
	
	para el caso en el que el usuario quiera acceder a una ruta no existente

=end

not_found do 
	"Solictud no disponible!"
end

=begin

JSON para tener una idea de como parsear el API:

{
	"coord"=>{"lon"=>-100.15, "lat"=>25.42}, 
	"sys"=>{"type"=>1, 
	"id"=>4002, 
	"message"=>0.0111, 
	"country"=>"MX", 
	"sunrise"=>1435578782, 
	"sunset"=>1435628119}, 
	"weather"=>[
					{
						"id"=>803, 
						"main"=>"Clouds", 
						"description"=>"broken clouds", 
						"icon"=>"04d"
					}
				], 
	"base"=>"stations", 
	"main"=>{
			"temp"=>298.86, 
			"pressure"=>1017, 
			"humidity"=>69, 
			"temp_min"=>297.15, 
			"temp_max"=>300.93
			}, 
	"visibility"=>8047, 
	"wind"=>{"speed"=>2.1, "deg"=>40}, 
	"clouds"=>{"all"=>75}, 
	"dt"=>1435593314, 
	"id"=>3983671, 
	"name"=>"Santiago", 
	"cod"=>200
}
=end
