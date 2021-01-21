import subprocess

# defines X, Y, SCREEN, WINDOW
exec(subprocess.check_output(['xdotool', 'getmouselocation', '--shell']))

subprocess.check_call(['i3-msg', '[id="{}"] focus'.format(WINDOW)])
