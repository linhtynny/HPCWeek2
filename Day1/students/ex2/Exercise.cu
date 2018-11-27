#include <thrust/scatter.h>
#include <thrust/gather.h>
#include <thrust/device_vector.h>
#include "Exercise.hpp"
#include "include/chronoGPU.hpp"

struct evenOddGather : public thrust::unary_function<const int, int>{
	const int N;
	evenOddGather(int size): N(size){}
	__device__ int operator()(const int &i){
		if ((i*2)<N){
			return (i*2);
		}else{
			return (1 +i*2 - N);
		}
		
	}
};

void Exercise::Question1(const thrust::host_vector<int>& A,
						 thrust::host_vector<int>& OE ) const
{
  // TODO: extract values at even and odd indices from A and put them into OE.
  // TODO: using GATHER
  thrust::device_vector<int> gpuA(A);
  thrust::device_vector<int> gpuOE(OE.size());

	thrust::counting_iterator<int>X(0);
	thrust::gather(//thrust::device, 
		thrust::make_transform_iterator(X, evenOddGather(gpuA.size())),
		thrust::make_transform_iterator(X + gpuA.size(), evenOddGather(gpuA.size())),
		gpuA.begin(),
		gpuOE.begin()
	);

	OE = gpuOE;
}



void Exercise::Question2(const thrust::host_vector<int>&A, 
						thrust::host_vector<int>&OE) const 
{
  // TODO: idem q1 using SCATTER
}




template <typename T>
void Exercise::Question3(const thrust::host_vector<T>& A,
						thrust::host_vector<T>&OE) const 
{
  // TODO: idem for big objects
}


struct MyDataType {
	MyDataType(int i) : m_i(i) {}
	MyDataType() = default;
	~MyDataType() = default;
	int m_i;
	operator int() const { return m_i; }

	// TODO: add what you want ...
};

// Warning: do not modify the following function ...
void Exercise::checkQuestion3() const {
	const size_t size = sizeof(MyDataType)*m_size;
	std::cout<<"Check exercice 3 with arrays of size "<<(size>>20)<<" Mb"<<std::endl;
	checkQuestion3withDataType(MyDataType(0));
}
