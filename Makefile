package:
	ls charts | xargs -I{} helm package charts/{} --destination .deploy