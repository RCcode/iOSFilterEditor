

#import "NCAmaroFilter.h"
NSString *const kNCAmaroShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 
 uniform float specIntensity;
 uniform float vignetteFlag;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 void main()
 {
     
     lowp vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     lowp vec3 texel2;
     lowp vec2 lookup;
     lookup.y = .5;
     lookup.x = texel.r;
     texel2.r = texture2D(inputImageTexture2, lookup).r;
     
     lookup.x = texel.g;
     texel2.g = texture2D(inputImageTexture2, lookup).g;
     
     lookup.x = texel.b;
     texel2.b = texture2D(inputImageTexture2, lookup).b;
     
     lowp vec4 filterResult = vec4(mix(texel, texel2, specIntensity), 1.0);
     
   if (vignetteFlag > .0){
        vec3 lumaCoeffs = vec3(.3, .59, .11);
       vec2 vignetteCenter = vec2( .5, .5);
       vec3 vignetteColor = vec3(.0, .0, .0);
       float vignetteStart = .3;
       float vignetteEnd = .70;
       float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
       float percent = smoothstep(vignetteStart, vignetteEnd, d);
      filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
    }
     
     gl_FragColor = filterResult;
 }
);
@interface NCAmaroFilter()
{

}

@end
@implementation NCAmaroFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kNCAmaroShaderString]))
    {
		return nil;
    }
//    filterPositionAttribute = [filterProgram attributeIndex:@"position"];
//    filterTextureCoordinateAttribute = [filterProgram attributeIndex:@"inputTextureCoordinate"];
//    filterInputTextureUniform = [filterProgram uniformIndex:@"inputImageTexture"]; // This does assume a name of "inputImageTexture" for the fragment shader
//    filterInputTextureUniform2 = [filterProgram uniformIndex:@"inputImageTexture2"]; // This does assume a name of "inputImageTexture2" for second input texture in the fragment shader
//    filterInputTextureUniform3 = [filterProgram uniformIndex:@"inputImageTexture3"]; // This does assume a name of "inputImageTexture3" for second input texture in the fragment shader
//    filterInputTextureUniform4 = [filterProgram uniformIndex:@"inputImageTexture4"]; // This does assume a name of "inputImageTexture4" for second input texture in the fragment shader
//    filterInputTextureUniform5 = [filterProgram uniformIndex:@"inputImageTexture5"]; // This does assume a name of "inputImageTexture5" for second input texture in the fragment shader
//    filterInputTextureUniform6 = [filterProgram uniformIndex:@"inputImageTexture6"]; // This does assume a name of "inputImageTexture6" for second input texture in the fragment shader
//    [filterProgram use];
//	glEnableVertexAttribArray(filterPositionAttribute);
//	glEnableVertexAttribArray(filterTextureCoordinateAttribute);
    return self;
}
//
//- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
//{
//    [GPUImageOpenGLESContext useImageProcessingContext];
//    [self setFilterFBO];
//    
//    [filterProgram use];
//    
//    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    
//	glActiveTexture(GL_TEXTURE2);
//	glBindTexture(GL_TEXTURE_2D, filterSourceTexture);
//    
//	glUniform1i(filterInputTextureUniform, 2);
//    
//    if (filterSourceTexture2 != 0)
//    {
//        glActiveTexture(GL_TEXTURE3);
//        glBindTexture(GL_TEXTURE_2D, filterSourceTexture2);
//        
//        glUniform1i(filterInputTextureUniform2, 3);
//    }
//    if (filterSourceTexture3 != 0)
//    {
//        glActiveTexture(GL_TEXTURE4);
//        glBindTexture(GL_TEXTURE_2D, filterSourceTexture3);
//        glUniform1i(filterInputTextureUniform3, 4);
//    }
//    if (filterSourceTexture4 != 0)
//    {
//        glActiveTexture(GL_TEXTURE5);
//        glBindTexture(GL_TEXTURE_2D, filterSourceTexture4);
//        glUniform1i(filterInputTextureUniform4, 5);
//    }
//    if (filterSourceTexture5 != 0)
//    {
//        glActiveTexture(GL_TEXTURE6);
//        glBindTexture(GL_TEXTURE_2D, filterSourceTexture5);
//        glUniform1i(filterInputTextureUniform5, 6);
//    }
//    if (filterSourceTexture6 != 0)
//    {
//        glActiveTexture(GL_TEXTURE7);
//        glBindTexture(GL_TEXTURE_2D, filterSourceTexture6);
//        glUniform1i(filterInputTextureUniform6, 7);
//    }
//    
//    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
//	glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
//    
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    
//    for (id<GPUImageInput2> currentTarget in targets)
//    {
//        [currentTarget setInputSize:inputTextureSize];
//        [currentTarget newFrameReady];
//    }
//}
//
//- (void)setFilterFBO;
//{
//    if (!filterFramebuffer) {
//        [self createFilterFBO];
//    }
//    
//    CGSize currentFBOSize = [self sizeOfFBO];
//    glViewport(0, 0, (int)currentFBOSize.width, (int)currentFBOSize.height);
//}
//
//- (void)createFilterFBO;
//{
//    glActiveTexture(GL_TEXTURE1);
//    glGenFramebuffers(1, &filterFramebuffer);
//    glBindFramebuffer(GL_FRAMEBUFFER, filterFramebuffer);
//    
//    CGSize currentFBOSize = [self sizeOfFBO];
//    
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, (int)currentFBOSize.width, (int)currentFBOSize.height);
//    glBindTexture(GL_TEXTURE_2D, outputTexture);
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)currentFBOSize.width, (int)currentFBOSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
//	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, outputTexture, 0);
//	
//	GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
//    
//    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);
//}
//
//- (CGSize)sizeOfFBO;
//{
//    CGSize outputSize = [self maximumOutputSize];
//    if ( (CGSizeEqualToSize(outputSize, CGSizeZero)) || (inputTextureSize.width < outputSize.width) )
//    {
//        return inputTextureSize;
//    }
//    else
//    {
//        return outputSize;
//    }
//}
//
//- (void)setInputTexture:(GLuint)newInputTexture atIndex:(NSInteger)textureIndex;
//{
//    if (textureIndex == 0)
//    {
//        filterSourceTexture = newInputTexture;
//    }
//    else if (filterSourceTexture2 == 0)
//    {
//        filterSourceTexture2 = newInputTexture;
//    }
//    else if (filterSourceTexture3 == 0) {
//        filterSourceTexture3 = newInputTexture;
//    }
//    else if (filterSourceTexture4 == 0) {
//        filterSourceTexture4 = newInputTexture;
//    }
//    else if (filterSourceTexture5 == 0) {
//        filterSourceTexture5 = newInputTexture;
//    }
//    else if (filterSourceTexture6 == 0) {
//        filterSourceTexture6 = newInputTexture;
//    }
//    
//}
//
//
//- (void)dealloc{
//    glDeleteFramebuffers(1, &filterFramebuffer);
//}
//


- (void)setSharder{
    [self setInteger:1 forUniformName:@"inputImageTexture"];
}
- (void)setInteger:(GLint)newInteger forUniform:(NSString *)uniformName;
{
    [GPUImageContext useImageProcessingContext];
    [filterProgram use];
    GLint uniformIndex = [filterProgram uniformIndex:uniformName];
    
    glUniform1i(uniformIndex, newInteger);
}

@end
