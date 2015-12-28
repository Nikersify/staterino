gulp = require('gulp')
del = require('del')

gulp.task('clean', function(){
	return del('public/')
})

gulp.task('move', ['clean'], function(){
	gulp.src('source/**')
		.pipe(gulp.dest('public/'))
})

gulp.task('watch', function(){
	gulp.watch('source/**', ['move'])
})

gulp.task('default', ['move', 'watch'])