#import Pkg
#Pkg.add("Luxor")
using Luxor
using SharedArrays
using Distributed

function dist(c)
	return sqrt(real(c)^2+imag(c)^2)
end

function calc(x,y,iter)
	z=Complex(0)
	c=x+y*im
	count=0
	#print(c)
	while (count<iter) && (dist(z)<=2)
		z = z^2 + c
		count+=1
	end
	#print(count," ")
	return count
end

function mandelbrot(ctrx, ctry, d, sc, iter, paralellism=10)
	n=Int(ceil(2*d/sc))
	#print("n=",n,"... ")
	#col=Array{SharedArray{Int}}(n)
	col=[]
	c=zeros(n)
	for i in 1:n
		c=zeros(n)
		#print(i)
		#c=SharedArray{Int}(n)
		#print(Int(ceil(n/paralellism)),"\n")
		for j in 1:(Int(ceil(n/paralellism)))
			Threads.@threads for k in 1:paralellism
				ind=(j-1)*paralellism+k
				if ind<=n
					#print("a=",ctrx-d+i*sc, ctry-d+j*sc,"\n")
					a = calc(ctrx - d + (i-1)*sc, ctry - d + (ind-1)*sc, iter)
					#append!(c,a)
					#print("(",i,",",ind,")=",a,"\n")
					c[ind]=a
				end
			end
			#print(c)
			#c=nothing
		end
		#print(c)
		append!(col,[c])
		#col[i]=c
		#c=nothing
	end
	#print(col)
	return col
end

function getColor(n, max)
	r=g=b=0
	if n<=max/3
		g=n/(max/3)
		r=1-g
	elseif n<=2*max/3
		g=n/(2*max/3)
		b=1-g
	elseif n<max
		b=n/(max)
		g=1-r
	end
	return(r,g,b)
end

function draw(p,iter, n)
	Luxor.Drawing(n,n)
	origin()
	#grestore()
	#print(p)
	#print(p[1])
	for i in 1:length(p)
		#print(p[i])
		for j in 1:length(p[i])
			c = getColor(p[i][j],iter)
			#print(c)
			sethue(c)
			circle(Luxor.Point(i-length(p)/2,j-length(p)/2), 1, :fill)
		end
	end
	gsave()
	finish()
	preview()
end

function main()
	iter=121
	paralellism=10000
	m = mandelbrot(-0.909, -0.275, 0.03, 0.00005, iter, paralellism)
	draw(m, iter, length(m))
end

main()
