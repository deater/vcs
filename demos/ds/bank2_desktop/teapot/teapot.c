/* roughly based on code from Rosetta Code */

#include <GL/gl.h>
#include <GL/glut.h>

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
	rot += 0.01;
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
