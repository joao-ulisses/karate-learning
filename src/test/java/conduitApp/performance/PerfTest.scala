package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {

    CreateTokens.createAccessTokens()

    val protocol = karateProtocol(
        "/api/articles/{articledId}" -> Nil
    )

    protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
//  protocol.runner.karateEnv("perf")
    val csvFeeder = csv("articles.csv").circular
    val tokenFeeder = Iterator.continually(Map("token" -> CreateTokens.getNextToken))

    val createArticle = scenario("Create and delete article")
        .feed(csvFeeder)
        .feed(tokenFeeder)
        .exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))

    setUp(createArticle.inject(
            atOnceUsers(3),
            // rampUsersPerSec(2) to 20 during (10 seconds),
            nothingFor(5 seconds),
            constantUsersPerSec(1) during (3 seconds)
        ).protocols(protocol)
    )
}