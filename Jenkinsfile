pipeline {
    agent any

    tools {
        jdk   'JDK-17'
        maven 'Maven-3'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    parameters {
        string(name: 'plateforme', defaultValue: 'Linux', description: 'Plateforme cible')
        choice(name: 'choix', choices: ['Linux', 'Windows', 'Mac'], description: 'Choix de plateforme')
    }

    stages {
        stage('Compilation') {
            steps {
                echo "Plateforme : ${params.plateforme} | Choix : ${params.choix}"
                echo "Compilation du projet Maven..."
                sh 'mvn clean compile -B -f /opt/calculatrice/pom.xml'
            }
        }

        stage('Tests Unitaires') {
            steps {
                echo "Exécution des tests unitaires..."
                sh 'mvn test -B -f /opt/calculatrice/pom.xml'
            }
            post {
                always {
                    sh 'cp -r /opt/calculatrice/target/surefire-reports .'
                    junit 'surefire-reports/*.xml'
                }
            }
        }

        stage('Couverture JaCoCo') {
            steps {
                echo "Génération du rapport de couverture JaCoCo..."
                sh 'mvn jacoco:report -B -f /opt/calculatrice/pom.xml'
            }
            post {
                always {
                    publishHTML(target: [
                        allowMissing         : false,
                        alwaysLinkToLastBuild: true,
                        keepAll              : true,
                        reportDir            : '/opt/calculatrice/target/site/jacoco',
                        reportFiles          : 'index.html',
                        reportName           : 'Rapport JaCoCo'
                    ])
                }
            }
        }

        stage('Package') {
            steps {
                echo "Création du JAR..."
                sh 'mvn package -DskipTests -B -f /opt/calculatrice/pom.xml'
                archiveArtifacts artifacts: '/opt/calculatrice/target/*.jar', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "Build réussi !"
        }
        unstable {
            echo "Build instable (des tests ont échoué)."
            mail(
                to:      'admin@jenkins.local',
                subject: "[Jenkins] Build INSTABLE : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body:    "Voir les détails : ${env.BUILD_URL}"
            )
        }
        failure {
            echo "Build en échec !"
            mail(
                to:      'admin@jenkins.local',
                subject: "[Jenkins] Build ECHEC : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body:    "Voir les détails : ${env.BUILD_URL}"
            )
        }
        always {
            cleanWs()
        }
    }
}
