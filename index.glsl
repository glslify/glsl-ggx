float ggx (vec3 N, vec3 V, vec3 L, float roughness, float F0) {
  float alpha = roughness*roughness;
  vec3 H = normalize(L - V);
  float dotLH = max(0.0, dot(L,H));
  float dotNH = max(0.0, dot(N,H));
  float dotNL = max(0.0, dot(N,L));
  float alphaSqr = alpha * alpha;
  float denom = dotNH * dotNH * (alphaSqr - 1.0) + 1.0;
  float D = alphaSqr / (3.141592653589793 * denom * denom);
  float F = F0 + (1.0 - F0) * pow(1.0 - dotLH, 5.0);
  float k = 0.5 * alpha;
  float k2 = k * k;
  return dotNL * D * F / (dotLH*dotLH*(1.0-k2)+k2);
}
#pragma glslify: export(ggx)
