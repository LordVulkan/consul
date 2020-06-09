require "rails_helper"

describe "Polymorphic routes" do
  def polymorphic_path(record, options = {})
    super(record, options.merge(only_path: true))
  end

  describe "polymorphic_path" do
    it "routes investments" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)

      expect(polymorphic_path(investment)).to eq budget_investment_path(budget, investment)
    end

    it "routes legislation proposals" do
      process = create(:legislation_process)
      proposal = create(:legislation_proposal, process: process)

      expect(polymorphic_path(proposal)).to eq legislation_process_proposal_path(process, proposal)
    end

    it "routes legislation questions" do
      process = create(:legislation_process)
      question = create(:legislation_question, process: process)

      expect(polymorphic_path(question)).to eq legislation_process_question_path(process, question)
    end

    it "routes legislation annotations" do
      process = create(:legislation_process)
      draft_version = create(:legislation_draft_version, process: process)
      annotation = create(:legislation_annotation, draft_version: draft_version)

      expect(polymorphic_path(annotation)).to eq(
        legislation_process_draft_version_annotation_path(process, draft_version, annotation)
      )
    end

    it "routes poll questions" do
      question = create(:poll_question)

      expect(polymorphic_path(question)).to eq question_path(question)
    end

    it "routes topics" do
      community = create(:proposal).community
      topic = create(:topic, community: community)

      expect(polymorphic_path(topic)).to eq community_topic_path(community, topic)
    end
  end

  describe "admin_polymorphic_path" do
    include ActionDispatch::Routing::UrlFor

    it "routes milestones for resources with no hierarchy" do
      proposal = create(:proposal)
      milestone = create(:milestone, milestoneable: proposal)

      expect(admin_polymorphic_path(milestone)).to eq(
        admin_proposal_milestone_path(proposal, milestone)
      )
    end

    it "routes milestones for resources with hierarchy" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)
      milestone = create(:milestone, milestoneable: investment)

      expect(admin_polymorphic_path(milestone)).to eq(
        admin_budget_budget_investment_milestone_path(budget, investment, milestone)
      )
    end

    it "routes progress bars for resources with no hierarchy" do
      proposal = create(:proposal)
      progress_bar = create(:progress_bar, progressable: proposal)

      expect(admin_polymorphic_path(progress_bar)).to eq(
        admin_proposal_progress_bar_path(proposal, progress_bar)
      )
    end

    it "routes progress_bars for resources with hierarchy" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)
      progress_bar = create(:progress_bar, progressable: investment)

      expect(admin_polymorphic_path(progress_bar)).to eq(
        admin_budget_budget_investment_progress_bar_path(budget, investment, progress_bar)
      )
    end

    it "routes audits" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)
      audit = investment.audits.create!

      expect(admin_polymorphic_path(audit)).to eq(
        admin_budget_budget_investment_audit_path(budget, investment, audit)
      )
    end

    it "supports routes for actions like edit" do
      proposal = create(:proposal)
      milestone = create(:milestone, milestoneable: proposal)

      expect(admin_polymorphic_path(milestone, action: :edit)).to eq(
        edit_admin_proposal_milestone_path(proposal, milestone)
      )
    end
  end
end
