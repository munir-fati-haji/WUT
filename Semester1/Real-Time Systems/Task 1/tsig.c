#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>

#define WITH_SIGNALS

#define NUM_CHILD  5

int mark=0;

void interrupt_handler(){
	mark=1;
	printf("Received keyboard interrupt \n");
}
void SIGTERM_handler(){
	printf("child[%d]: received SIGTERM signal, terminating \n",getpid());
}


int main(){
    #ifdef WITH_SIGNALS
        for(int i=1;i<NSIG ;i++){
            signal(i, SIG_IGN);
        }
        signal(SIGCHLD, SIG_DFL);
        signal(SIGINT, interrupt_handler);

        int count=0,status;
        pid_t pid[NUM_CHILD];

        for(int i=0;i<NUM_CHILD ;i++){
            
            pid[i] = fork();	
            if (pid[i]==0){
                signal(SIGINT, SIG_IGN);
                signal(SIGTERM, SIGTERM_handler);
                printf("child[%d] created with parent[%d]\n",getpid(),getppid());
                sleep(10);
                printf("Terminated child[%d] with parent[%d]\n",getpid(),getppid());
                exit(0);
            }else if(pid[i]<0){
                printf("Error: Failed to create child process\n");
                kill(0,SIGTERM);
                exit(1);
            }
            sleep(1);
            if (mark==1) {
                kill(0,SIGTERM);
                printf("parent[%d]: sending SIGTERM signal\n", getpid());
                break;
            }
        }

        while(wait(&status) != -1 || errno != ECHILD){
            ++count;
        }
        printf("[%d] child processes has completed Execution with parent[%d] with exit code[%d]\n",count,getpid(),status);
        
        for(int i=1;i<NSIG ;i++){
            signal(i, SIG_DFL);
        }
    #else
        int count=0,status;
        pid_t pid[NUM_CHILD];
        for(int i=0;i<NUM_CHILD ;i++){
            pid[i] = fork();	
            if (pid[i]==0){
                printf("child[%d] created with parent[%d]\n",getpid(),getppid());
                sleep(10);
                printf("Terminated child[%d] with parent[%d]\n",getpid(),getppid());
                exit(0);
            }else if(pid[i]<0){
                printf("Error: Failed to create child process\n");
                kill(0,SIGTERM);
                exit(1);
            }
            sleep(1);
        }
        printf("All child processes are created with parent[%d]\n",getpid());

        while(wait(&status) != -1 || errno != ECHILD){
            ++count;
        }
        printf("All [%d] child processes has completed Execution with parent[%d] with status [%d]\n",count,getpid(),status);
    #endif

    return 0;
}