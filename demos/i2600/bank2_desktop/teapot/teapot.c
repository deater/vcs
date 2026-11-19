/* roughly based on code from Rosetta Code */

#include <GL/gl.h>
#include <GL/glut.h>

#include <unistd.h>
#include <stdio.h>

static double rot = 0;

static void display(void) {

	/* clear */
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	glPushMatrix();

	/* degrees */
	/* axis of rotation */
	glRotatef(rot,0,1,1);

	/* generate wireframe teapot, argument is size */
	glutWireTeapot(0.5);
	glPopMatrix();
	glFlush();
}

/* rotate on idle */
static void onIdle(void) {
//	ror+=0.01;
	rot += 45;		// 40 is 9, 45 roughly 8
//	sleep(1);
	char string[100];
	fgets(string,100,stdin);
	glutPostRedisplay();
}


int main(int argc, char **argv) {

	/* init glut */
	glutInit(&argc,argv);
	glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB|GLUT_DEPTH);

	/* create window */
	glutInitWindowSize(60,60);
	glutCreateWindow("Utah Teapot");

	/* setup functions */
	glutDisplayFunc(display);
	glutIdleFunc(onIdle);

	/* loop forever */
	glutMainLoop();

	return 0;
}
