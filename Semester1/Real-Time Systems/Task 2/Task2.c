// Task #2
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <string.h>
#include <sys/sem.h>
#define N 5
#define THINKING 0
#define HUNGRY 1
#define EATING 2
#define LEFT (i + N - 1) % N
#define RIGHT (i + 1) % N
struct shm
{
    int state[N];
} *shared_memory;
void Initialize_shared_memory()
{
    /* to create share memory section */
    int shmId;
    shmId = shmget(IPC_PRIVATE, sizeof(*shared_memory), IPC_CREAT | 0666);
    if (shmId < 0)
    {
        printf("*** shmget error (server) ***\n");
        exit(1);
    }
    else
    {
        printf("Memory attached at shmid %d\n", shmId);
    }
    shared_memory = (struct shm *)shmat(shmId, NULL, 0); /* attach */
    if (shared_memory < 0)
    {
        printf("*** shmat error (server) ***\n");
        exit(1);
    }
    else
    {
        printf("Shmat success\n");
    }
}
union semun
{
    int val;
    struct semid_ds *buf;
    unsigned short *array;
    struct seminfo *_buf;
};
int semId;
void philosopher(int i);
void take_forks(int i);
void put_forks(int i);
void test(int i);
void up(int i);
void down(int i);
int main()
{
    semId = semget(IPC_PRIVATE, N + 1, 0666 | IPC_CREAT);
    if (semId < 0)
    {
        perror("semget");
        exit(1);
    }
    else
    {
        printf("Semaphores group id: %d\n", semId);
    }
    union semun u;
    u.array = malloc(N + 1 * sizeof(ushort));
    for (int j = 0; j < N; j++)
    {
        u.array[j] = 0;
    }
    u.array[N] = 1;
    if (semctl(semId, 0, SETALL, u) < 0)
    {
        perror("semctl");
        exit(1);
    }
    pid_t processID[N]; // Process ID
    int i;
    Initialize_shared_memory();
    for (int k = 0; k < N; k++)
    {
        shared_memory->state[k] = HUNGRY;
    }
    for (i = 0; i < N; i++)
    {
        processID[i] = fork(); // Create each philosopher
        if (processID[i] == 0)
        {
            // checks that the philosopher processes have been created correctly
            philosopher(i);
        }
        else if (processID[i] < 0)
        {
            fprintf(stderr, "fork() FAILED! error: %d \n", errno); // error message that fork failed
            for (int j = 0; j < i; j++)
            {
                kill(processID[j], SIGTERM);
            }
            exit(1);
        }
        else if (processID[i] > 0)
        {
            printf(" parent[%d] - inside parent process.\n", getpid()); // message that we are in parent process
        }
        sleep(1); // delay 1 second
    }
    printf(" parent[%d] - All philosopher processes have been created!\n", getpid()); // message that all philosopher processes are created
    int numTerminated = 0;
    while (wait(NULL) > 0) // wait until no more philosopher processes need to be sychronized with the parent
    {
        ++numTerminated; // counting finished philosopher processes
    }
    printf("No more processes to be sychronized.\n%d philosopher processes terminated!\n", numTerminated);
    return 0;
}
void philosopher(int i)
{
    while (1)
    {
        printf("philosopher[%d] - this philosopher is thinking.\n", getpid());
        sleep(10);
        take_forks(i);
        printf("philosopher[%d] - this philosopher is eating.\n", getpid());
        sleep(10);
        put_forks(i);
    }
}
void take_forks(int i)
{
    down(N);
    shared_memory->state[i] = HUNGRY;
    test(i);
    up(N);
    down(i);
}
void put_forks(int i)
{
    down(N);
    shared_memory->state[i] = THINKING;
    test(LEFT);
    test(RIGHT);
    up(N);
}
void test(int i)
{
    if (shared_memory->state[i] == HUNGRY &&
        shared_memory->state[LEFT] != EATING &&
        shared_memory->state[RIGHT] != EATING)
    {
        shared_memory->state[i] = EATING;
        up(i);
    }
}
void up(int i)
{
    struct sembuf u = {i, +1, SEM_UNDO};
    if (semop(semId, &u, 1) < 0)
    {
        perror("semop up");
        exit(1);
    }
}
void down(int i)
{
    struct sembuf d = {i, -1, SEM_UNDO};
    if (semop(semId, &d, 1) < 0)
    {
        perror("semop down");
        exit(1);
    }
}
