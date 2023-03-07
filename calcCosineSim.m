function cosineSimilarity = calcCosineSim(v1,v2)

cosineSimilarity = dot(v1,v2)./(norm(v1)*norm(v2));