# Use the official Neo4j image as a parent image
FROM neo4j:5-community

# Set environment variables for Neo4j authentication
ENV NEO4J_AUTH=neo4j/iotmalware

# Set the working directory to the Neo4j installation directory in the container image
RUN chown -R neo4j:neo4j /data

# Copy the database dump file to the import directory
COPY neo4j_5.18.1_maintaned.dump /var/lib/neo4j/import/neo4j.dump

# Load the database dump file into the Neo4j database before starting the Neo4j server
RUN bin/neo4j-admin database load --from-path=/var/lib/neo4j/import --overwrite-destination=true --verbose neo4j

# Expose the Neo4j port
EXPOSE 7474 7687

# Start the Neo4j server
CMD ["neo4j"]