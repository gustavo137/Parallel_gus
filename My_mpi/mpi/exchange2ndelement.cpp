#include <mpi.h>
#include <iostream>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    const int array_size = 10;
    int data[array_size];

    if (rank == 0) {
        for (int i = 0; i < array_size; i++) {
            data[i] = i;
        }

     // Define a vector datatype for sending every 2nd element
     MPI_Datatype vector_type;
     MPI_Type_vector(5, 1, 2, MPI_INT, &vector_type);  // Send 5 blocks, each block 1 int, stride 2
     MPI_Type_commit(&vector_type);

     MPI_Send(data, 1, vector_type, 1, 0, MPI_COMM_WORLD);
     MPI_Type_free(&vector_type);
    } else if (rank == 1) {
        for (int i = 0; i < array_size; i++) {data[i] = -1; }
  
     MPI_Recv(data, 5, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);  // 5 ints

     std::cout << "Process 1 received data: ";
     for (int i = 0; i < array_size; i++) {
            std::cout << data[i] << " ";
     }
     std::cout << std::endl;
    }//else if

    MPI_Finalize();
    return 0;
}
