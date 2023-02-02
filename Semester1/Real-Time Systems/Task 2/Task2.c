#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <unistd.h>

#define N 5
#define THINKING 0
#define HUNGRY 1
#define EATING 2
#define LEFT (i + N - 1) % N
#define RIGHT (i + 1) % N

int shmid;
int sem_group;

struct shm
{
    int state[N];
} *shared_memory;

union semun
{
    int val;               /* Value for SETVAL */
    struct semid_ds *buf;  /* Buffer for IPC_STAT, IPC_SET */
    unsigned short *array; /* Array for GETALL, SETALL */
    struct seminfo *__buf; /* Buffer for IPC_INFO (Linux-specific) */
} semaphores;

int Initialize_shared_memory()
{

    shmid = shmget(IPC_PRIVATE, sizeof(*shared_memory), IPC_CREAT | 0666);

    if (shmid != -1)
    {
        printf("Memory attached at shmid %d\n", shmid);
    }

    shared_memory = (struct shm *)shmat(shmid, NULL, 0);

    if (shared_memory != (void *)-1)
    {
        printf("Shmat succeed\n");
    }

    for (int i = 0; i < N; i++)
    {
        shared_memory->state[i] = HUNGRY;
    }
}

int initialize_semaphores()
{

    sem_group = semget(IPC_PRIVATE, N + 1, IPC_CREAT | 0666);

    if (sem_group != -1)
    {
        printf("Semaphores group id: %d\n", sem_group);
    }

    semaphores.array = malloc(N + 1 * sizeof(ushort));

    for (int i = 0; i < N; i++)
    {
        semaphores.array[i] = 0;
    }

    semaphores.array[N] = 1;

    if (semctl(sem_group, 0, SETALL, semaphores) != -1)
    {
        printf("Semaphore initation succeed\n");
    }
}
void up(int i)
{
    struct sembuf my_sem_b = {i, 1, SEM_UNDO};

    if (semop(sem_group, &my_sem_b, 1) < 0)
    {
        fprintf(stderr, "semaphore failed\n");
    }
}

void down(int i)
{
    struct sembuf my_sem_b = {i, -1, SEM_UNDO};

    if (semop(sem_group, &my_sem_b, 1) < 0)
    {
        fprintf(stderr, "semaphore failed\n");
    }
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

int main()
{
    int count = 0, status;
    Initialize_shared_memory();
    initialize_semaphores();

    pid_t pid[N];
    for (int i = 0; i < N; i++)
    {
        pid[i] = fork();
        if (pid[i] == 0)
        {
            philosopher(i);
            exit(0);
        }
        else if (pid[i] < 0)
        {
            printf("Error: Failed to create child process\n");
            kill(0, SIGTERM);
            exit(1);
        }
        sleep(1);
    }

    while (wait(&status) != -1 || errno != ECHILD)
    {
        ++count;
    }

    printf("All [%d] child processes has completed Execution with parent[%d] with status [%d]\n", count, getpid(), status);

    return 0;
}
