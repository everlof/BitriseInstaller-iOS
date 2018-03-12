import Foundation

struct Me: Codable {
    let avatarUrl: String
    let slug: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case slug
        case username
    }
}

struct App: Codable {
    struct User: Codable {
        let accountType: String
        let name: String
        let slug: String

        enum CodingKeys: String, CodingKey {
            case accountType = "account_type"
            case name
            case slug
        }
    }

    let isDisabled: Bool
    let isPublic: Bool
    let owner: User
    let projectType: String
    let provider: String
    let repoOwner: String
    let repoSlug: String
    let repoUrl: String
    let slug: String
    let status: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case isDisabled = "is_disabled"
        case isPublic = "is_public"
        case owner
        case projectType = "project_type"
        case provider
        case repoOwner = "repo_owner"
        case repoSlug = "repo_slug"
        case repoUrl = "repo_url"
        case slug
        case status
        case title
    }
}

struct Build: Codable {
    enum Status: Int, Codable {
        case notFinishedYet = 0
        case finishedWithSuccess = 1
        case finishedWithError = 2
        case aborted = 3
    }

    struct OriginalBuildParams: Codable {
        let branch: String?
        let commitHash: String?
        let commitMessage: String?

        enum CodingKeys: String, CodingKey {
            case branch = "is_disabled"
            case commitHash = "commit_hash"
            case commitMessage = "commit_message"
        }
    }

    let abortReason: String?
    let branch: String
    let buildNumber: Int
    let commitHash: String?
    let commitMessage: String?
    let commitViewURL: String?
    let environmentPrepareFinishedAt: Date?
    let finishedAt: Date?
    let isOnHold: Bool
    let originalBuildParams: OriginalBuildParams
    let pullRequestId: Int?
    let pullRequestTargetBranch: String?
    let pullRequestViewURL: String?
    let slug: String
    let stackConfigType: String
    let stackIdentifier: String
    let startedOnWorkerAt: Date?
    let status: Status
    let statusText: String
    let tag: String?
    let triggeredAt: Date?
    let triggeredBy: String?
    let triggeredWorkflow: String

    enum CodingKeys: String, CodingKey {
        case abortReason = "abort_reason"
        case branch = "branch"
        case buildNumber = "build_number"
        case commitHash = "commit_hash"
        case commitMessage = "commit_message"
        case commitViewURL = "commit_view_url"
        case environmentPrepareFinishedAt = "environment_prepare_finished_at"
        case finishedAt = "finished_at"
        case isOnHold = "is_on_hold"
        case originalBuildParams = "original_build_params"
        case pullRequestId = "pull_request_id"
        case pullRequestTargetBranch = "pull_request_target_branch"
        case pullRequestViewURL = "pull_request_view_url"
        case slug = "slug"
        case stackConfigType = "stack_config_type"
        case stackIdentifier = "stack_identifier"
        case startedOnWorkerAt = "started_on_worker_at"
        case status = "status"
        case statusText = "status_text"
        case tag = "tag"
        case triggeredAt = "triggered_at"
        case triggeredBy = "triggered_by"
        case triggeredWorkflow = "triggered_workflow"
    }
}

struct Artifact: Codable {

    enum ArtifactType: String, Codable {
        case file = "file"
        case ipa = "ios-ipa"
    }

    let slug: String
    let title: String
    let artifactType: ArtifactType
    let fileSizeBytes: Int64
    let isPublicPageEnabled: Bool
    let expiringDownloadURL: String?
    let publicInstallPageURL: String?

    enum CodingKeys: String, CodingKey {
        case slug
        case title
        case artifactType = "artifact_type"
        case fileSizeBytes = "file_size_bytes"
        case isPublicPageEnabled = "is_public_page_enabled"
        case expiringDownloadURL = "expiring_download_url"
        case publicInstallPageURL = "public_install_page_url"
    }
}
