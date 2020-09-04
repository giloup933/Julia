function padding(arr, n) # add padding of zeroes
	if length(arr)>=n
		return arr
	end
	for i in length(arr):n-1
		append!(arr, 0)
	end
	return arr
end

function dft(p, n)
	if n==1
		return p
	end
	#Divide step
	even = filter((x) -> x%2 == 0, collect(1:n))
	odd = filter((x) -> x%2 == 1, collect(1:n))
	p1 = deepcopy(p)
	p2 = deepcopy(p)
	#print(p1)
	deleteat!(p1,even)
	deleteat!(p2,odd)
	p1 = dft(p1, div(n+1, 2)) # div(n1,n2) is integer division with floor result, ÷
	p2 = dft(p2, div(n, 2))
	omega = exp(im*2*pi/n)
	#print(omega,"\n\n")
	o = 1.0
	for k in 1:(div(length(p),2))
		#print(k,p1,p2,p,"\n")
		#print(o,",",p2[k],"\n")
		p[k] = p1[k] + o*p2[k]
		p[k+(div(n,2))] = p1[k]-o*p2[k]
		o = o*omega
	end
	return p
end

function inv(pts, n)
	if n==1
		return pts
	end
	even = filter((x) -> x%2 == 0, collect(1:n))
	odd = filter((x) -> x%2 == 1, collect(1:n))
	d1 = deepcopy(pts)
	d2 = deepcopy(pts)
	deleteat!(d1,even)
	deleteat!(d2,odd)
	#print("???",d1,"\n")
	#print("%%%",d2,"\n")
	p1 = inv(d1, div(n+1, 2)) # div(n1,n2) is integer division with floor result, ÷
	p2 = inv(d2, div(n, 2))
	#print("\n^^^",p1,p2,"&&&")
	#print("\n^^^^^",vcat(p1,p2),"^^&&\n")
	a=Array{Complex}([])
	b=Array{Complex}([])
	omega = 1/exp(im*2*pi/n)
	o=1.0
	#print("!!!",p1,p2)
	for k in 1:(div(n,2))
		append!(a, real(p1[k]+o*p2[k]))
		append!(b, real(p1[k]-o*p2[k]))
		o = o*omega
	end
	return vcat(a, b)
end

function fft(p1, p2)
	#l = max(length(p1), length(p2))
	#l = ceil(log2(l))
	l = Int16(2^(ceil(log2(length(p1)+length(p2)-1))))
	#print(l)
	for i in 1:(l-length(p1))
		append!(p1, 0) # padding
	end
	for i in 0:(l-length(p2))
		append!(p2, 0)
	end
	d1 = dft(Array{Complex}(p1), l)
	d2 = dft(Array{Complex}(p2), l)
	d = Array{Complex}([])
	for k in 1:l
		append!(d,d1[k]*d2[k])
	end
	return inv(d,l)/l
end

#dft(collect([1,3,5,7,9,10,11,12]), 8)

function main()
	arr1 = [1,3,9]
	arr2 = [3,5,7]

	#a = dft(collect(Array{Complex}([1,3,5,7,9,10,11,12])), 8)
	mult = fft(Array{Complex}(arr1), Array{Complex}(arr2))
	#print(mult,"\n\n")
	#mult = inv(mult, 8)
	#print(mult,"\n")
	#print(length(mult),"\n")
	print(Array{Float16}(mult),"\n")
end

main()
