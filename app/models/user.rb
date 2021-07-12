class User < ApplicationRecord
      before_create :generate_confirmation_instructions
      after_create :welcome_send

      has_secure_password
      validates :email, presence: { message: "can't be blank" }, 'valid_email_2/email': { message: "is not a valid email" }
      validates_uniqueness_of :email
      # validates :mobile, format: { with:/\A\d{3} \d{3} \d{3}\z/, message: "phone number invalide" }
      validates :name,  presence: { message: "can't be blank" }
      validates :first_name,  presence: { message: "can't be blank" }
      validates :date_of_birth,  presence: { message: "can't be blank" }

      mount_uploader :piece, PhotoUploader
      
      has_many :logements, dependent: :destroy
      
      has_one_attached :featured_image, dependent: :destroy   
      
      has_many :conversations
      has_many :logements, through: :conversations
      
      has_many :reservations, dependent: :destroy
      
      has_many :commentaires, dependent: :destroy
  
      has_many :facture_versements, dependent: :destroy

      has_one:coordone_bancaire, dependent: :destroy
      
      def welcome_send 
        # CompteMailer.welcome_email(self).deliver_now
      end

      # Generate a token, store it inside confirmation_token and send it within email
      def generate_confirmation_instructions
        self.confirmation_token = SecureRandom.hex(10)
        self.confirmation_sent_at = Time.now.utc
      end

      # Set a validation time to confirmation token sent
      def confirmation_token_valid?
        (self.confirmation_sent_at + 30.days) > Time.now.utc
      end
      
      # When an account is confirmed, set confirmation_token null and set confirmed_at into Time now
      def mark_as_confirmed!
        self.confirmation_token = nil
        self.confirmed_at = Time.now.utc
        save
      end
    end
